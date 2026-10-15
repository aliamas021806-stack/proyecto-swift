import Foundation
import SwiftData

@MainActor
public final class AppointmentLocalStore {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Mapping helpers

    private func entity(from model: AppointmentModel) -> AppointmentEntity {
        return AppointmentEntity(id: model.id,
                                 remoteId: model.remoteId,
                                 patientId: model.patientId,
                                 patientName: model.patientName,
                                 doctorName: model.doctorName,
                                 specialty: model.specialty,
                                 appointmentDescription: model.description,
                                 status: model.status,
                                 appointmentDate: model.appointmentDate,
                                 durationMinutes: model.durationMinutes,
                                 createdAt: model.createdAt,
                                 updatedAt: model.updatedAt,
                                 synchronizationState: model.synchronizationState.rawValue)
    }

    private func model(from entity: AppointmentEntity) -> AppointmentModel {
        return AppointmentModel(id: entity.id,
                                remoteId: entity.remoteId,
                                patientId: entity.patientId,
                                patientName: entity.patientName,
                                doctorName: entity.doctorName,
                                specialty: entity.specialty,
                                description: entity.appointmentDescription,
                                status: entity.status,
                                appointmentDate: entity.appointmentDate,
                                durationMinutes: entity.durationMinutes,
                                createdAt: entity.createdAt,
                                updatedAt: entity.updatedAt,
                                synchronizationState: SyncState(rawValue: entity.synchronizationState) ?? .synchronized)
    }

    // MARK: - CRUD

    public func fetchAll() async throws -> [AppointmentModel] {
        let fetch = FetchDescriptor<AppointmentEntity>()
        let entities = try context.fetch(fetch)
        return entities.map { model(from: $0) }
    }

    public func fetch(id: UUID) async throws -> AppointmentModel? {
        let fetch = FetchDescriptor<AppointmentEntity>(predicate: #Predicate { $0.id == id })
        let entities = try context.fetch(fetch)
        return entities.first.map { model(from: $0) }
    }

    public func create(_ appointment: AppointmentModel) async throws -> AppointmentModel {
        let entity = entity(from: appointment)
        context.insert(entity)
        try context.save()
        return model(from: entity)
    }

    public func update(_ appointment: AppointmentModel) async throws -> AppointmentModel {
        let fetch = FetchDescriptor<AppointmentEntity>(predicate: #Predicate { $0.id == appointment.id })
        let results = try context.fetch(fetch)
        guard let existing = results.first else {
            return try await create(appointment)
        }
        // Update mutable properties
        existing.remoteId = appointment.remoteId
        existing.patientId = appointment.patientId
        existing.patientName = appointment.patientName
        existing.doctorName = appointment.doctorName
        existing.specialty = appointment.specialty
        existing.appointmentDescription = appointment.description
        existing.status = appointment.status
        existing.appointmentDate = appointment.appointmentDate
        existing.durationMinutes = appointment.durationMinutes
        existing.updatedAt = appointment.updatedAt
        existing.synchronizationState = appointment.synchronizationState.rawValue
        try context.save()
        return model(from: existing)
    }

    public func delete(_ appointment: AppointmentModel) async throws {
        let fetch = FetchDescriptor<AppointmentEntity>(predicate: #Predicate { $0.id == appointment.id })
        let results = try context.fetch(fetch)
        for e in results { context.delete(e) }
        try context.save()
    }

    // MARK: - Helpers for synchronization state

    public func markPendingCreation(_ id: UUID) async throws {
        let fetch = FetchDescriptor<AppointmentEntity>(predicate: #Predicate { $0.id == id })
        let results = try context.fetch(fetch)
        guard let e = results.first else { return }
        e.synchronizationState = SyncState.pendingCreation.rawValue
        try context.save()
    }

    public func pendingChanges() async throws -> [AppointmentModel] {
        let fetch = FetchDescriptor<AppointmentEntity>(predicate: #Predicate { $0.synchronizationState != SyncState.synchronized.rawValue })
        let results = try context.fetch(fetch)
        return results.map { model(from: $0) }
    }
}

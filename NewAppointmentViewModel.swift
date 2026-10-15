import Foundation
import SwiftData

@MainActor
public final class NewAppointmentViewModel: ObservableObject {
    @Published public var isSaving: Bool = false
    @Published public var saved: Bool = false
    @Published public var errorMessage: String? = nil

    private var repository: AppointmentRepositoryProtocol?
    private var configured = false

    public init(repository: AppointmentRepositoryProtocol? = nil) {
        self.repository = repository
    }

    public func configure(context: ModelContext) {
        if configured { return }
        configured = true
        if repository == nil {
            repository = RepositoryFactory.makeRepository(context: context)
        }
    }

    /// Create an appointment using provided fields. Returns the created model.
    public func createAppointment(patientId: Int?, patientName: String, doctorName: String, specialty: String, description: String?, appointmentDate: Date, durationMinutes: Int) async throws -> AppointmentModel {
        guard let repo = repository else { throw NSError(domain: "NewAppointmentViewModel", code: 1) }
        let model = AppointmentModel(remoteId: nil,
                                     patientId: patientId,
                                     patientName: patientName,
                                     doctorName: doctorName,
                                     specialty: specialty,
                                     description: description ?? "",
                                     status: "pending",
                                     appointmentDate: appointmentDate,
                                     durationMinutes: durationMinutes,
                                     createdAt: Date(),
                                     updatedAt: Date(),
                                     synchronizationState: .pendingCreation)
        isSaving = true
        do {
            let created = try await repo.create(model)
            isSaving = false
            saved = true
            return created
        } catch {
            isSaving = false
            errorMessage = String(describing: error)
            throw error
        }
    }
}

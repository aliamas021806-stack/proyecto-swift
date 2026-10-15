import XCTest
@testable import GestorCitas
import SwiftData

final class AppointmentLocalStoreTests: XCTestCase {

    private func makeInMemoryPersistence() throws -> PersistenceController {
        return try PersistenceController(inMemory: true)
    }

    func testCRUD_createFetchUpdateDelete() async throws {
        let persistence = try makeInMemoryPersistence()
        let context = persistence.container.newBackgroundContext()
        let store = AppointmentLocalStore(context: context)

        // Create model
        let model = AppointmentModel(
            id: UUID(),
            remoteId: nil,
            patientId: 42,
            patientName: "Paciente Test",
            doctorName: "Dr. Test",
            specialty: "Testología",
            description: "Motivo",
            status: "pendiente",
            appointmentDate: Date(),
            durationMinutes: 30,
            createdAt: Date(),
            updatedAt: Date(),
            synchronizationState: .synchronized
        )

        // Create
        let created = try await MainActor.run { try await store.create(model) }
        XCTAssertEqual(created.patientName, "Paciente Test")

        // Fetch all
        let all = try await MainActor.run { try await store.fetchAll() }
        XCTAssertEqual(all.count, 1)

        // Fetch by id
        let fetched = try await MainActor.run { try await store.fetch(id: created.id) }
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.patientName, "Paciente Test")

        // Update
        var toUpdate = created
        toUpdate.description = "Motivo actualizado"
        let updated = try await MainActor.run { try await store.update(toUpdate) }
        XCTAssertEqual(updated.description, "Motivo actualizado")

        // Delete
        try await MainActor.run { try await store.delete(updated) }
        let afterDelete = try await MainActor.run { try await store.fetchAll() }
        XCTAssertEqual(afterDelete.count, 0)
    }

    func testPendingChanges_and_markPendingCreation() async throws {
        let persistence = try makeInMemoryPersistence()
        let context = persistence.container.newBackgroundContext()
        let store = AppointmentLocalStore(context: context)

        let model = AppointmentModel(
            id: UUID(),
            remoteId: nil,
            patientId: 1,
            patientName: "Local Only",
            doctorName: "Dr. Local",
            specialty: "Locología",
            description: "Creada local",
            status: "pendiente",
            appointmentDate: Date(),
            durationMinutes: 20,
            createdAt: Date(),
            updatedAt: Date(),
            synchronizationState: .synchronized
        )

        let created = try await MainActor.run { try await store.create(model) }
        // Mark pending creation
        try await MainActor.run { try await store.markPendingCreation(created.id) }

        let pendings = try await MainActor.run { try await store.pendingChanges() }
        XCTAssertTrue(pendings.contains(where: { $0.id == created.id && $0.synchronizationState == .pendingCreation }))
    }
}

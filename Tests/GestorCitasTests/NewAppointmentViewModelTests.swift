import XCTest
@testable import GestorCitas

final class NewAppointmentViewModelTests: XCTestCase {

    // A lightweight mock repository to avoid network calls
    final class MockRepository: AppointmentRepositoryProtocol {
        var createCalled = false
        var createdModels: [AppointmentModel] = []

        func fetchAll() async throws -> [AppointmentModel] { [] }
        func fetch(id: UUID) async throws -> AppointmentModel? { nil }
        func create(_ appointment: AppointmentModel) async throws -> AppointmentModel {
            createCalled = true
            // simulate network latency
            try await Task.sleep(nanoseconds: 200_000_000)
            // return a mapped model with a remoteId assigned
            let mapped = AppointmentModel(id: appointment.id,
                                          remoteId: Int.random(in: 100...999),
                                          patientId: appointment.patientId,
                                          patientName: appointment.patientName,
                                          doctorName: appointment.doctorName,
                                          specialty: appointment.specialty,
                                          description: appointment.description,
                                          status: "pending",
                                          appointmentDate: appointment.appointmentDate,
                                          durationMinutes: appointment.durationMinutes,
                                          createdAt: appointment.createdAt,
                                          updatedAt: Date(),
                                          synchronizationState: .synchronized)
            createdModels.append(mapped)
            return mapped
        }
        func update(_ appointment: AppointmentModel) async throws -> AppointmentModel { appointment }
        func delete(_ appointment: AppointmentModel) async throws {}
        func synchronizePendingChanges() async throws {}
    }

    func testParseAppointmentDate_withTomorrow_returnsFutureDate() async throws {
        let vm = NewAppointmentViewModel()

        // pick tomorrow day
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let dayComponent = calendar.component(.day, from: tomorrow)

        let result = await MainActor.run { vm.parseAppointmentDate(selectedDay: dayComponent, selectedSlot: "09:00") }
        XCTAssertNotNil(result)
        if let date = result {
            XCTAssertTrue(date > Date(), "Parsed date should be in the future")
        }
    }

    func testParseAppointmentDate_withPastDay_returnsNextMonthDateOrNil() async throws {
        let vm = NewAppointmentViewModel()
        let calendar = Calendar.current
        // pick a day safely in the past (1st of the current month if today >5)
        let today = Date()
        let day = max(1, calendar.component(.day, from: today) - 5)

        let result = await MainActor.run { vm.parseAppointmentDate(selectedDay: day, selectedSlot: "09:00") }
        // Parser should either return a future date in next month or nil if impossible; ensure not returning past date
        if let d = result {
            XCTAssertTrue(d > Date(), "Returned date must be in the future")
        }
    }

    func testValidate_missingFields_setsErrors() async throws {
        let vm = NewAppointmentViewModel()

        // No patient, empty description, no date, zero duration
        let valid = await MainActor.run { vm.validate(patientId: nil, patientName: "", description: "", appointmentDate: nil, durationMinutes: 0) }
        XCTAssertFalse(valid)
        await MainActor.run {
            XCTAssertNotNil(vm.patientError)
            XCTAssertNotNil(vm.descriptionError)
            XCTAssertNotNil(vm.dateError)
            XCTAssertNotNil(vm.durationError)
            XCTAssertEqual(vm.patientError, "Paciente obligatorio")
            XCTAssertEqual(vm.descriptionError, "Motivo de la consulta obligatorio")
            XCTAssertEqual(vm.durationError, "Duración debe ser mayor que 0")
        }
    }

    func testCreateBlocksDoubleSubmission_and_setsSavedOnSuccess() async throws {
        let mock = MockRepository()
        let vm = NewAppointmentViewModel(repository: mock)

        // Prepare valid inputs: use tomorrow for date
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let dayComponent = calendar.component(.day, from: tomorrow)
        let slot = "09:00"

        // Start first create but don't await it immediately
        let firstTask = Task { try await vm.createAppointmentFromUI(selectedDay: dayComponent, selectedSlot: slot, patientId: 1, patientName: "Test", doctorName: "Dr", specialty: "Spec", description: "Motivo", durationMinutes: 30) }

        // Small yield to ensure the first Task reaches the point of setting isSaving if possible
        try await Task.sleep(nanoseconds: 10_000_000)

        // Second call should throw due to double submission protection
        var didThrow = false
        do {
            _ = try await vm.createAppointmentFromUI(selectedDay: dayComponent, selectedSlot: slot, patientId: 1, patientName: "Test", doctorName: "Dr", specialty: "Spec", description: "Motivo", durationMinutes: 30)
        } catch {
            didThrow = true
        }
        XCTAssertTrue(didThrow, "Second submission should be rejected while saving")

        // Await first completion and verify saved state
        let created = try await firstTask.value
        XCTAssertTrue(vm.saved, "ViewModel should mark saved = true after success")
        XCTAssertTrue(mock.createCalled, "Repository.create should have been called")
        XCTAssertEqual(mock.createdModels.first?.patientName, "Test")
        XCTAssertEqual(created.patientName, "Test")
    }
}

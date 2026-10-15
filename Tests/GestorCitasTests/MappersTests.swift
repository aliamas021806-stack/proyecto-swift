import XCTest
@testable import GestorCitas

final class MappersTests: XCTestCase {

    func testAppointmentModel_fromPostDTO_withValidCompactTitle_parsesAllFields() async throws {
        let iso = "2026-10-20T09:00:00Z"
        let title = ["confirmada", "Dra. Elena", "Cardiología", iso, "45"].joined(separator: "|")
        let dto = PostDTO(userId: 7, id: 123, title: title, body: "Control rutinario")
        let localId = UUID()

        let model = appointmentModel(from: dto, localId: localId)

        XCTAssertEqual(model.id, localId)
        XCTAssertEqual(model.remoteId, 123)
        XCTAssertEqual(model.patientId, 7)
        XCTAssertEqual(model.description, "Control rutinario")
        XCTAssertEqual(model.doctorName, "Dra. Elena")
        XCTAssertEqual(model.specialty, "Cardiología")
        XCTAssertEqual(model.status, "confirmada")
        XCTAssertEqual(model.durationMinutes, 45)

        // appointmentDate parsed correctly
        let formatter = ISO8601DateFormatter()
        let expected = formatter.date(from: iso)
        XCTAssertNotNil(expected)
        if let expected = expected {
            let diff = abs(model.appointmentDate.timeIntervalSince1970 - expected.timeIntervalSince1970)
            XCTAssertLessThan(diff, 1.0, "Dates should match within 1s")
        }
    }

    func testAppointmentModel_fromPostDTO_withMalformedTitle_usesDefaults() async throws {
        let dto = PostDTO(userId: nil, id: nil, title: "unparseable title", body: "No structured data")
        let model = appointmentModel(from: dto, localId: nil)

        XCTAssertEqual(model.patientId, nil)
        XCTAssertEqual(model.remoteId, nil)
        XCTAssertEqual(model.description, "No structured data")
        XCTAssertEqual(model.doctorName, "")
        XCTAssertEqual(model.specialty, "")
        XCTAssertEqual(model.status, "pending")
        XCTAssertEqual(model.durationMinutes, 30)
    }
}

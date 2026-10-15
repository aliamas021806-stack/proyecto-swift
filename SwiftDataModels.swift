import Foundation
import SwiftData

// SwiftData model para persistencia local de citas. Usamos @Model disponible en iOS 17+.
// Este archivo es solo la definición del modelo; la integración con un container se hará
// en pasos posteriores.

@Model
final class AppointmentEntity {
    @Attribute(.unique) var id: UUID
    var remoteId: Int?
    var patientId: Int?
    var patientName: String
    var doctorName: String
    var specialty: String
    var appointmentDescription: String
    var status: String
    var appointmentDate: Date
    var durationMinutes: Int
    var createdAt: Date
    var updatedAt: Date
    var synchronizationState: String

    init(id: UUID = UUID(), remoteId: Int? = nil, patientId: Int? = nil, patientName: String = "", doctorName: String = "", specialty: String = "", appointmentDescription: String = "", status: String = "pending", appointmentDate: Date = Date(), durationMinutes: Int = 30, createdAt: Date = Date(), updatedAt: Date = Date(), synchronizationState: String = "synchronized") {
        self.id = id
        self.remoteId = remoteId
        self.patientId = patientId
        self.patientName = patientName
        self.doctorName = doctorName
        self.specialty = specialty
        self.appointmentDescription = appointmentDescription
        self.status = status
        self.appointmentDate = appointmentDate
        self.durationMinutes = durationMinutes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.synchronizationState = synchronizationState
    }
}

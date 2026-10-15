import Foundation

// Modelo de dominio (nombre distinto al existente en UI para evitar conflictos)
// Se mapeará al modelo UI en pasos posteriores.

public enum SyncState: String, Codable, Sendable {
    case synchronized
    case pendingCreation
    case pendingUpdate
    case pendingDeletion
    case failed
}

public struct AppointmentModel: Identifiable, Codable, Sendable {
    public let id: UUID
    public var remoteId: Int? // id en JSONPlaceholder (post.id)
    public var patientId: Int?
    public var patientName: String
    public var doctorName: String
    public var specialty: String
    public var description: String
    public var status: String
    public var appointmentDate: Date
    public var durationMinutes: Int
    public var createdAt: Date
    public var updatedAt: Date
    public var synchronizationState: SyncState

    public init(id: UUID = UUID(), remoteId: Int? = nil, patientId: Int? = nil, patientName: String = "", doctorName: String = "", specialty: String = "", description: String = "", status: String = "pending", appointmentDate: Date = Date(), durationMinutes: Int = 30, createdAt: Date = Date(), updatedAt: Date = Date(), synchronizationState: SyncState = .synchronized) {
        self.id = id
        self.remoteId = remoteId
        self.patientId = patientId
        self.patientName = patientName
        self.doctorName = doctorName
        self.specialty = specialty
        self.description = description
        self.status = status
        self.appointmentDate = appointmentDate
        self.durationMinutes = durationMinutes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.synchronizationState = synchronizationState
    }
}

import Foundation

// Mappers entre PostDTO <-> AppointmentModel

private func parseCompactTitle(_ title: String) -> (status: String, doctor: String, specialty: String, appointmentISO: String?, duration: Int?) {
    // Esperamos un formato compacto, por ejemplo: "status|doctor|specialty|2024-10-24T09:00:00Z|30"
    // Si no coincide, devolvemos defaults seguros.
    let parts = title.split(separator: "|")
    guard parts.count >= 3 else {
        return (status: "pending", doctor: "", specialty: "", appointmentISO: nil, duration: nil)
    }
    let status = String(parts[0])
    let doctor = String(parts[1])
    let specialty = String(parts[2])
    let appointmentISO = parts.count > 3 ? String(parts[3]) : nil
    let duration = parts.count > 4 ? Int(String(parts[4])) : nil
    return (status, doctor, specialty, appointmentISO, duration)
}

/// Crea un AppointmentModel a partir de PostDTO.
/// Si se pasa `localId`, se preserva ese UUID (útil cuando la entidad local ya existe).
public func appointmentModel(from dto: PostDTO, localId: UUID? = nil) -> AppointmentModel {
    let compact = parseCompactTitle(dto.title)
    let appointmentDate: Date
    if let iso = compact.appointmentISO, let date = ISO8601DateFormatter().date(from: iso) {
        appointmentDate = date
    } else {
        appointmentDate = Date() // default seguro
    }
    let duration = compact.duration ?? 30
    return AppointmentModel(
        id: localId ?? UUID(),
        remoteId: dto.id,
        patientId: dto.userId,
        patientName: "Paciente \(dto.userId ?? 0)",
        doctorName: compact.doctor,
        specialty: compact.specialty,
        description: dto.body,
        status: compact.status,
        appointmentDate: appointmentDate,
        durationMinutes: duration,
        createdAt: Date(),
        updatedAt: Date(),
        synchronizationState: .synchronized
    )
}

public func postDTO(from model: AppointmentModel) -> PostDTO {
    // Armamos title compact
    let iso = ISO8601DateFormatter().string(from: model.appointmentDate)
    let title = [model.status, model.doctorName, model.specialty, iso, String(model.durationMinutes)].joined(separator: "|")
    return PostDTO(userId: model.patientId, id: model.remoteId, title: title, body: model.description)
}

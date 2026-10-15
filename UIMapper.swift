import Foundation

import SwiftUI

/// Map from domain AppointmentModel -> UI Appointment used by the views.
public func uiAppointment(from model: AppointmentModel) -> Appointment {
    // Minimal mapping: map names and create Patient/Doctor placeholders where needed.
    let patient = Patient(name: model.patientName, age: 0, dni: "—", avatarSeed: "p_\(model.id)")
    let doctor = Doctor(name: model.doctorName.isEmpty ? "Dr." : model.doctorName, specialty: model.specialty, room: "", avatarSeed: "d_\(model.id)")

    // derive startTime/endTime/meridiem from appointmentDate for display — fallbacks
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm"
    let start = formatter.string(from: model.appointmentDate)
    let endDate = Calendar.current.date(byAdding: .minute, value: model.durationMinutes, to: model.appointmentDate) ?? model.appointmentDate
    let end = formatter.string(from: endDate)
    let hourFormatter = DateFormatter()
    hourFormatter.dateFormat = "a"
    let meridiem = hourFormatter.string(from: model.appointmentDate)

    return Appointment(id: model.id,
                       code: "",
                       startTime: start,
                       endTime: end,
                       startMeridiem: meridiem,
                       patient: patient,
                       doctor: doctor,
                       status: AppointmentStatus(rawValue: model.status) ?? .pendiente,
                       modality: .presencial,
                       reason: model.description,
                       durationMinutes: model.durationMinutes)
}

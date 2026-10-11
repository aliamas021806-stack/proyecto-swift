//
//  Models.swift
//  GestorCitas
//
//  Modelos de dominio y datos de ejemplo que alimentan las pantallas.
//

import SwiftUI

// MARK: - Estado de la cita

enum AppointmentStatus: String, CaseIterable, Identifiable {
    case confirmada   = "Confirmada"
    case pendiente    = "Pendiente"
    case enConsulta   = "En Consulta"
    case cancelada    = "Cancelada"
    case enEspera     = "En Espera"

    var id: String { rawValue }

    /// Color del punto indicador y del texto.
    var dotColor: Color {
        switch self {
        case .confirmada: return AppColor.secondary
        case .pendiente:  return AppColor.amber
        case .enConsulta: return AppColor.primaryContainer
        case .cancelada:  return AppColor.error
        case .enEspera:   return AppColor.secondary
        }
    }

    /// Fondo del badge tipo píldora.
    var badgeBackground: Color {
        switch self {
        case .confirmada: return AppColor.secondaryFixed.opacity(0.5)
        case .pendiente:  return AppColor.amberSoft
        case .enConsulta: return AppColor.primaryFixed
        case .cancelada:  return AppColor.errorContainer
        case .enEspera:   return AppColor.secondaryContainer.opacity(0.5)
        }
    }

    /// Color del texto del badge.
    var badgeText: Color {
        switch self {
        case .confirmada: return AppColor.secondary
        case .pendiente:  return AppColor.amberDeep
        case .enConsulta: return AppColor.primary
        case .cancelada:  return AppColor.error
        case .enEspera:   return AppColor.onSecondaryContainer
        }
    }

    /// Color del acento lateral (leading border) de la tarjeta.
    var accent: Color {
        switch self {
        case .confirmada: return AppColor.secondary
        case .pendiente:  return AppColor.amber
        case .enConsulta: return AppColor.primary
        case .cancelada:  return AppColor.error
        case .enEspera:   return AppColor.secondary
        }
    }
}

// MARK: - Modalidad

enum AppointmentModality: String, CaseIterable {
    case presencial   = "Presencial"
    case telemedicina = "Telemedicina"

    var icon: String {
        switch self {
        case .presencial:   return "building.2"
        case .telemedicina: return "video"
        }
    }
}

// MARK: - Paciente

struct Patient: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
    let dni: String
    let avatarSeed: String          // usado para avatar generado
    var bloodType: String? = nil
    var allergies: [String] = []
    var insurance: String? = nil
    var previousVisits: Int = 0
    var phone: String? = nil
    var isChild: Bool = false
    var tutor: String? = nil
}

// MARK: - Doctor

struct Doctor: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let specialty: String
    let room: String
    let avatarSeed: String
    var isOnline: Bool = true
    var license: String? = nil
}

// MARK: - Cita

struct Appointment: Identifiable, Hashable {
    let id = UUID()
    var code: String
    var startTime: String            // "09:00"
    var endTime: String              // "09:30"
    var startMeridiem: String        // "AM"
    var patient: Patient
    var doctor: Doctor
    var status: AppointmentStatus
    var modality: AppointmentModality
    var reason: String? = nil
    var durationMinutes: Int = 30

    var timeRange: String { "\(startTime) \(startMeridiem) - \(endTime) \(startMeridiem)" }

    /// Iniciales para el avatar de texto (p. ej. "CM").
    var initials: String {
        let parts = patient.name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + last).uppercased()
    }
}

// MARK: - Filtros rápidos del dashboard

enum QuickFilter: String, CaseIterable, Identifiable {
    case todas = "Todas (18)"
    case cardiologia = "Cardiología"
    case pediatria = "Pediatría"
    case telemedicina = "Telemedicina"
    case confirmadas = "Confirmadas"
    var id: String { rawValue }
}

// MARK: - Período del dashboard

enum PeriodFilter: String, CaseIterable, Identifiable {
    case hoy = "Hoy"
    case manana = "Mañana"
    case semana = "Esta semana"
    var id: String { rawValue }
}

// MARK: - Datos de ejemplo

enum SampleData {

    // Pacientes
    static let carlos = Patient(
        name: "Carlos Mendoza Ruiz", age: 42, dni: "48.291.034",
        avatarSeed: "carlos", bloodType: "A+", insurance: "Sanitas Plus", previousVisits: 6
    )
    static let sofia = Patient(
        name: "Sofía Valdés Navarro", age: 28, dni: "51.392.881",
        avatarSeed: "sofia", bloodType: "O+", allergies: ["Penicilina"],
        insurance: "Sanitas Activo", previousVisits: 4, phone: "+34600123456"
    )
    static let mateo = Patient(
        name: "Mateo Gómez Pardo", age: 9, dni: "—",
        avatarSeed: "mateo", isChild: true, tutor: "Ana Pardo"
    )
    static let lucia = Patient(
        name: "Lucía Herrera Gil", age: 64, dni: "32.890.119",
        avatarSeed: "lucia", bloodType: "B-", insurance: "Adeslas", previousVisits: 12
    )
    static let mateoHernandez = Patient(
        name: "Mateo Hernández Cruz", age: 35, dni: "72.109.834-B",
        avatarSeed: "mateoH", insurance: "Sanitas Plus"
    )
    static let andres = Patient(
        name: "Andrés Castro", age: 51, dni: "29.114.552",
        avatarSeed: "andres", insurance: "Sanitas Plus", previousVisits: 3
    )

    // Doctores
    static let elena = Doctor(name: "Dra. Elena Morales", specialty: "Cardiología", room: "Consultorio 3B", avatarSeed: "elena", license: "Col. 28094")
    static let varela = Doctor(name: "Dr. Julián Varela", specialty: "Dermatología", room: "Consultorio 2A", avatarSeed: "varela")
    static let roberto = Doctor(name: "Dr. Roberto Silva", specialty: "Cirugía Gral.", room: "Box Quirúrgico 2", avatarSeed: "roberto", isOnline: false)
    static let alejandro = Doctor(name: "Dr. Alejandro Castillo", specialty: "Medicina Interna", room: "Cons. 204", avatarSeed: "alejandro")

    // Citas del dashboard
    static let dashboardAppointments: [Appointment] = [
        Appointment(
            code: "MD-8841", startTime: "09:00", endTime: "09:30", startMeridiem: "AM",
            patient: carlos, doctor: elena, status: .enConsulta, modality: .presencial
        ),
        Appointment(
            code: "MD-8842", startTime: "10:00", endTime: "10:45", startMeridiem: "AM",
            patient: sofia, doctor: varela, status: .confirmada, modality: .telemedicina,
            durationMinutes: 45
        ),
        Appointment(
            code: "MD-8843", startTime: "11:15", endTime: "11:45", startMeridiem: "AM",
            patient: mateo, doctor: roberto, status: .pendiente, modality: .presencial
        ),
        Appointment(
            code: "MD-8844", startTime: "12:30", endTime: "01:00", startMeridiem: "PM",
            patient: lucia, doctor: elena, status: .confirmada, modality: .presencial
        ),
    ]

    // Agenda del día (calendario) — incluye huecos libres y pausa
    static let agendaItems: [AgendaItem] = [
        .free(time: "08:30", meridiem: "AM", title: "Disponible para consulta", subtitle: "Box 104 • Admisión inmediata"),
        .appointment(Appointment(
            code: "MD-8841", startTime: "09:00", endTime: "09:45", startMeridiem: "AM",
            patient: carlos, doctor: elena, status: .confirmada, modality: .presencial, durationMinutes: 45
        )),
        .appointment(Appointment(
            code: "MD-8842", startTime: "10:00", endTime: "10:30", startMeridiem: "AM",
            patient: sofia, doctor: varela, status: .confirmada, modality: .telemedicina
        )),
        .free(time: "11:00", meridiem: "AM", title: "Hueco libre disponible", subtitle: "Franja de 30 min para sobrecupo"),
        .appointment(Appointment(
            code: "MD-8845", startTime: "11:30", endTime: "12:15", startMeridiem: "AM",
            patient: andres, doctor: roberto, status: .confirmada, modality: .presencial,
            reason: "Revisión post-operatoria", durationMinutes: 45
        )),
        .appointment(Appointment(
            code: "MD-8844", startTime: "12:30", endTime: "01:00", startMeridiem: "PM",
            patient: lucia, doctor: elena, status: .enEspera, modality: .presencial,
            reason: "Chequeo Anual"
        )),
        .breakTime(time: "01:00", meridiem: "PM", title: "Pausa Clínica / Guardia Médica", subtitle: "Desinfección de gabinetes y cambio de turno", minutes: 90),
    ]

    // Especialistas para el selector del calendario
    static let specialists: [Doctor] = [elena, varela, roberto]

    // Horarios disponibles para "Nueva Cita"
    static let morningSlots: [SlotOption] = [
        .init(time: "09:00", available: true),
        .init(time: "09:30", available: false),
        .init(time: "10:00", available: true),
        .init(time: "10:30", available: true),
        .init(time: "11:15", available: true),
    ]
    static let afternoonSlots: [SlotOption] = [
        .init(time: "16:00", available: true),
        .init(time: "16:30", available: true),
        .init(time: "17:00", available: false),
    ]
}

// MARK: - Item de agenda (unión de tipos)

enum AgendaItem: Identifiable {
    case appointment(Appointment)
    case free(time: String, meridiem: String, title: String, subtitle: String)
    case breakTime(time: String, meridiem: String, title: String, subtitle: String, minutes: Int)

    var id: String {
        switch self {
        case .appointment(let a): return a.id.uuidString
        case .free(let t, _, _, _): return "free-\(t)"
        case .breakTime(let t, _, _, _, _): return "break-\(t)"
        }
    }

    var time: String {
        switch self {
        case .appointment(let a): return a.startTime
        case .free(let t, _, _, _): return t
        case .breakTime(let t, _, _, _, _): return t
        }
    }

    var meridiem: String {
        switch self {
        case .appointment(let a): return a.startMeridiem
        case .free(_, let m, _, _): return m
        case .breakTime(_, let m, _, _, _): return m
        }
    }
}

// MARK: - Opción de franja horaria

struct SlotOption: Identifiable, Hashable {
    let id = UUID()
    let time: String
    let available: Bool
}

// MARK: - Día de la semana (mini calendario)

struct DayChip: Identifiable, Hashable {
    let id = UUID()
    let label: String      // "Lun"
    let day: Int           // 21
    let hasAppointments: Bool
    var isSelected: Bool = false
}

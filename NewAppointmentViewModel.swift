import Foundation
import SwiftData

@MainActor
public final class NewAppointmentViewModel: ObservableObject {
    @Published public var isSaving: Bool = false
    @Published public var saved: Bool = false
    @Published public var errorMessage: String? = nil

    // Field-specific error messages
    @Published public var patientError: String? = nil
    @Published public var descriptionError: String? = nil
    @Published public var dateError: String? = nil
    @Published public var durationError: String? = nil

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

    // Parse selectedDay (day of month) and selectedSlot ("HH:mm") into a Date in the future.
    // Strategy: try current month; if resulting date is in the past, try next month.
    public func parseAppointmentDate(selectedDay: Int, selectedSlot: String?) -> Date? {
        guard let slot = selectedSlot else { return nil }
        let parts = slot.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else { return nil }

        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .timeZone], from: now)
        components.day = selectedDay
        components.hour = hour
        components.minute = minute
        components.second = 0

        // Try current month
        if let candidate = calendar.date(from: components), candidate > now {
            return candidate
        }

        // Try next month
        if var nextComponents = components as DateComponents? {
            if let month = components.month {
                nextComponents.month = month + 1
            }
            // Normalize date (calendar will handle year rollover)
            if let nextCandidate = calendar.date(from: nextComponents), nextCandidate > now {
                return nextCandidate
            }
        }

        return nil
    }

    // Validate inputs, set field errors; returns true if valid.
    public func validate(patientId: Int?, patientName: String, description: String?, appointmentDate: Date?, durationMinutes: Int) -> Bool {
        // Reset
        patientError = nil
        descriptionError = nil
        dateError = nil
        durationError = nil
        errorMessage = nil

        var ok = true

        if patientId == nil && patientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            patientError = "Paciente obligatorio"
            ok = false
        }

        if let d = description?.trimmingCharacters(in: .whitespacesAndNewlines), d.isEmpty {
            descriptionError = "Motivo de la consulta obligatorio"
            ok = false
        }

        if let date = appointmentDate {
            if date <= Date() {
                dateError = "La fecha y hora deben ser en el futuro"
                ok = false
            }
        } else {
            dateError = "Selecciona día y horario"
            ok = false
        }

        if durationMinutes <= 0 {
            durationError = "Duración debe ser mayor que 0"
            ok = false
        }

        return ok
    }

    /// Create an appointment from UI-provided values (selectedDay + selectedSlot are parsed here).
    /// This method performs validation, sets field errors, blocks double submission and returns the created model or throws.
    public func createAppointmentFromUI(selectedDay: Int, selectedSlot: String?, patientId: Int?, patientName: String, doctorName: String, specialty: String, description: String?, durationMinutes: Int) async throws -> AppointmentModel {
        guard !isSaving else { throw NSError(domain: "NewAppointmentViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Already saving"]) }

        // Ensure repository configured
        guard let repo = repository else { throw NSError(domain: "NewAppointmentViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Repository not configured"]) }

        // Parse date
        let appointmentDate = parseAppointmentDate(selectedDay: selectedDay, selectedSlot: selectedSlot)

        // Validate
        let valid = validate(patientId: patientId, patientName: patientName, description: description, appointmentDate: appointmentDate, durationMinutes: durationMinutes)
        guard valid else { throw NSError(domain: "Validation", code: 1, userInfo: [NSLocalizedDescriptionKey: "Validation failed"]) }

        // Build model
        let model = AppointmentModel(remoteId: nil,
                                     patientId: patientId,
                                     patientName: patientName,
                                     doctorName: doctorName,
                                     specialty: specialty,
                                     description: description ?? "",
                                     status: "pending",
                                     appointmentDate: appointmentDate!,
                                     durationMinutes: durationMinutes,
                                     createdAt: Date(),
                                     updatedAt: Date(),
                                     synchronizationState: .pendingCreation)

        isSaving = true
        errorMessage = nil
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

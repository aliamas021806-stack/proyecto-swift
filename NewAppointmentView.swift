import SwiftUI
import SwiftData

struct NewAppointmentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel = NewAppointmentViewModel()

    @State private var selectedDay: Int = 24
    @State private var selectedSlot: String? = "10:00"
    @State private var modality: AppointmentModality = .presencial
    @State private var reason: String = ""
    @State private var reminderOn = true
    @State private var fastingOn = false
    @State private var durationMinutes: Int = 30

    private let days: [(String, Int, Bool)] = [
        ("Lun", 21, true), ("Mar", 22, true), ("Mié", 23, true),
        ("Jue", 24, true), ("Vie", 25, true),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                stepper
                patientSummary
                doctorSummary
                dateTimePicker
                modalityAndReason
            }
            .padding(.horizontal, AppSpacing.marginSM)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, 120)
        }
        .background(AppColor.surface)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { bottomBar }
        .navigationTitle("Nueva Cita")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.configure(context: modelContext)
        }
    }

    // MARK: Stepper

    private var stepper: some View {
        HStack(spacing: 0) {
            stepCircle(label: "Paciente", number: 1, state: .done)
            connector(done: true)
            stepCircle(label: "Médico", number: 2, state: .done)
            connector(done: true)
            stepCircle(label: "Horario", number: 3, state: .active)
            connector(done: false)
            stepCircle(label: "Detalles", number: 4, state: .pending)
        }
        .padding(16)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    private enum StepState { case done, active, pending }

    private func stepCircle(label: String, number: Int, state: StepState) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(state == .done ? AppColor.secondaryContainer
                          : state == .active ? AppColor.primaryContainer
                          : AppColor.surfaceContainerHigh)
                    .frame(width: 36, height: 36)
                if state == .done {
                    Image(systemName: "checkmark").font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColor.onSecondaryContainer)
                } else {
                    Text("\(number)").font(AppFont.labelMD).fontWeight(.bold)
                        .foregroundStyle(state == .active ? AppColor.onPrimary : AppColor.onSurfaceVariant)
                }
            }
            .overlay(
                Circle().stroke(state == .active ? AppColor.primaryFixed.opacity(0.6) : .clear, lineWidth: 4)
            )
            Text(label)
                .font(AppFont.labelSM)
                .fontWeight(state == .active ? .bold : .regular)
                .foregroundStyle(state == .done ? AppColor.secondary
                                 : state == .active ? AppColor.primary
                                 : AppColor.onSurfaceVariant)
        }
    }

    private func connector(done: Bool) -> some View {
        Rectangle()
            .fill(done ? AppColor.secondaryContainer : AppColor.surfaceContainerHigh)
            .frame(height: 3)
            .frame(maxWidth: .infinity)
            .offset(y: -10)
    }

    // MARK: Paso 1 · Paciente

    private var patientSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill").font(.system(size: 15)).foregroundStyle(AppColor.secondary)
                    Text("PASO 1 · PACIENTE VERIFICADO")
                        .font(AppFont.labelSM).fontWeight(.semibold).foregroundStyle(AppColor.secondary)
                }
                Spacer()
                Button {} label: {
                    Text("Cambiar").font(AppFont.labelSM).foregroundStyle(AppColor.primary)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(AppColor.surfaceContainer)
                        .clipShape(Capsule())
                }.buttonStyle(.plain)
            }
            HStack(spacing: 12) {
                AvatarView(name: SampleData.mateoHernandez.name,
                           seed: SampleData.mateoHernandez.avatarSeed, size: 48)
                VStack(alignment: .leading, spacing: 3) {
                    Text(SampleData.mateoHernandez.name).font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.text.rectangle").font(.system(size: 12))
                            Text(SampleData.mateoHernandez.dni)
                        }
                        .font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                        HStack(spacing: 4) {
                            Circle().fill(AppColor.secondary).frame(width: 6, height: 6)
                            Text("Sanitas Plus")
                        }
                        .font(AppFont.labelSM).foregroundStyle(AppColor.onSecondaryFixed)
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(AppColor.secondaryFixed)
                        .clipShape(Capsule())
                    }
                }
            }
            if let err = viewModel.patientError {
                Text(err).font(AppFont.labelSM).foregroundColor(.red)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Paso 2 · Médico

    private var doctorSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "stethoscope").font(.system(size: 15)).foregroundStyle(AppColor.secondary)
                    Text("PASO 2 · ESPECIALISTA ASIGNADO")
                        .font(AppFont.labelSM).fontWeight(.semibold).foregroundStyle(AppColor.secondary)
                }
                Spacer()
                Image(systemName: "lock.fill").font(.system(size: 14)).foregroundStyle(AppColor.outline)
            }
            HStack(spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    AvatarView(name: SampleData.alejandro.name, seed: SampleData.alejandro.avatarSeed, size: 44)
                    Circle().fill(AppColor.secondary).frame(width: 12, height: 12)
                        .overlay(Circle().stroke(AppColor.surfaceContainerLowest, lineWidth: 2))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(SampleData.alejandro.name).font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                    HStack(spacing: 6) {
                        Text(SampleData.alejandro.specialty).font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                        Text("•").foregroundStyle(AppColor.outlineVariant)
                        HStack(spacing: 3) {
                            Image(systemName: "door.left.hand.open").font(.system(size: 12))
                            Text(SampleData.alejandro.room)
                        }
                        .font(AppFont.labelSM).fontWeight(.medium).foregroundStyle(AppColor.primary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 14)).foregroundStyle(AppColor.onSurfaceVariant)
            }
            .padding(10)
            .background(AppColor.surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Paso 3 · Fecha y horario

    private var dateTimePicker: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar.badge.clock").font(.system(size: 15)).foregroundStyle(AppColor.primary)
                    Text("Fecha y Horario").font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                }
                Spacer()
                Text("Octubre 2024").font(AppFont.labelSM).fontWeight(.semibold).foregroundStyle(AppColor.primary)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(AppColor.primaryFixed.opacity(0.5))
                    .clipShape(Capsule())
            }

            HStack(spacing: 8) {
                ForEach(days, id: \.1) { day in
                    dayChip(label: day.0, number: day.1, hasAppts: day.2, selected: selectedDay == day.1)
                        .onTapGesture { selectedDay = day.1 }
                }
            }

+            if let dateErr = viewModel.dateError {
+                Text(dateErr).font(AppFont.labelSM).foregroundColor(.red)
+            }
+
            // Turno mañana
            slotGroup(title: "Turno Mañana", icon: "sun.max", slots: SampleData.morningSlots)
            // Turno tarde
            slotGroup(title: "Turno Tarde", icon: "sunset", slots: SampleData.afternoonSlots)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    private func dayChip(label: String, number: Int, hasAppts: Bool, selected: Bool) -> some View {
        VStack(spacing: 3) {
            Text(label).font(AppFont.labelSM)
                .foregroundStyle(selected ? AppColor.onPrimaryContainer : AppColor.onSurfaceVariant)
            Text("\(number)").font(AppFont.headlineMD).fontWeight(.bold)
                .foregroundStyle(selected ? AppColor.onPrimary : AppColor.onSurface).monospacedDigit()
            Circle().fill(selected ? Color.white : (hasAppts ? AppColor.secondary : .clear))
                .frame(width: 6, height: 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(selected ? AppColor.primaryContainer : AppColor.surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .scaleEffect(selected ? 1.02 : 1)
    }

    private func slotGroup(title: String, icon: String, slots: [SlotOption]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 13)).foregroundStyle(AppColor.onSurfaceVariant)
                Text(title.uppercased()).font(AppFont.labelSM).fontWeight(.semibold).foregroundStyle(AppColor.onSurfaceVariant)
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(slots) { slot in
                    slotButton(slot)
                }
            }
        }
    }

    private func slotButton(_ slot: SlotOption) -> some View {
        let selected = selectedSlot == slot.time
        return Button {
            if slot.available { selectedSlot = slot.time }
        } label: {
            Text(slot.time)
                .font(AppFont.labelMD)
                .fontWeight(selected ? .semibold : .regular)
                .foregroundStyle(slot.available
                                 ? (selected ? AppColor.onPrimary : AppColor.onSurface)
                                 : AppColor.outline)
                .strikethrough(!slot.available)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(selected ? AppColor.primaryContainer : AppColor.surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!slot.available)
    }

    // MARK: Paso 4 · Modalidad y motivo

    private var modalityAndReason: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "square.and.pencil").font(.system(size: 15)).foregroundStyle(AppColor.primary)
                Text("Modalidad y Motivo").font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
            }

            HStack(spacing: 8) {
                modalityButton(.presencial, icon: "building.2.fill", title: "Presencial (Clínica)")
                modalityButton(.telemedicina, icon: "video.fill", title: "Telemedicina HD")
            }

+            // Duration control
+            VStack(alignment: .leading, spacing: 6) {
+                HStack {
+                    Text("Duración (min)").font(AppFont.labelSM)
+                    Spacer()
+                    Stepper(value: $durationMinutes, in: 5...240, step: 5) {
+                        Text("\(durationMinutes) min").font(AppFont.labelSM)
+                    }
+                    .frame(width: 160)
+                }
+                if let durErr = viewModel.durationError {
+                    Text(durErr).font(AppFont.labelSM).foregroundColor(.red)
+                }
+            }
+
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Motivo de consulta / Síntomas").font(AppFont.labelSM).fontWeight(.semibold).foregroundStyle(AppColor.onSurfaceVariant)
                    Spacer()
                    Text("Opcional").font(AppFont.labelSM).foregroundStyle(AppColor.outline)
                }
                TextEditor(text: $reason)
                    .font(AppFont.bodyMD)
                    .foregroundStyle(AppColor.onSurface)
                    .scrollContentBackground(.hidden)
                    .frame(height: 80)
                    .padding(8)
                    .background(AppColor.surfaceContainerLow)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                    .overlay(alignment: .topLeading) {
                        if reason.isEmpty {
                            Text("Ej. Control rutinario de hipertensión y revisión de análisis...")
                                .font(AppFont.bodyMD).foregroundStyle(AppColor.outline)
                                .padding(.horizontal, 12).padding(.vertical, 16)
                                .allowsHitTesting(false)
                        }
                    }
                if let descErr = viewModel.descriptionError {
                    Text(descErr).font(AppFont.labelSM).foregroundColor(.red)
                }
            }

            ClinicalToggle(icon: "envelope.badge", title: "Recordatorio digital",
                           subtitle: "Vía WhatsApp y correo 24h antes", iconTint: AppColor.secondary, isOn: $reminderOn)
            ClinicalToggle(icon: "fork.knife", title: "Preparación previa",
                           subtitle: "Requiere 8 horas de ayunas", iconTint: AppColor.onSurfaceVariant, isOn: $fastingOn)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    private func modalityButton(_ mode: AppointmentModality, icon: String, title: String) -> some View {
        let selected = modality == mode
        return Button { modality = mode } label: {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 16))
                Text(title).font(AppFont.labelMD)
            }
            .foregroundStyle(selected ? AppColor.onPrimary : AppColor.onSurface)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(selected ? AppColor.primaryContainer : AppColor.surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: Barra inferior

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Text("Cancelar")
                    .font(AppFont.labelLG).foregroundStyle(AppColor.onSurface)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColor.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            }.buttonStyle(.plain)

            Button {
                Task {
                    await performSave()
                }
            } label: {
                HStack(spacing: 8) {
                    if viewModel.isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle.fill").font(.system(size: 18))
                    }
                    Text(viewModel.saved ? "¡Cita Reservada con Éxito!" : (viewModel.isSaving ? "Guardando cita..." : "Confirmar y Reservar"))
                        .font(AppFont.labelLG)
                }
                .foregroundStyle(AppColor.onPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.saved ? AppColor.secondary : AppColor.primaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isSaving || viewModel.saved)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, AppSpacing.marginSM)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    private func performSave() async {
        viewModel.configure(context: modelContext)

        // Using placeholders for patient/doctor in this increment
        let patientId: Int? = 1
        let patientName = SampleData.mateoHernandez.name
        let doctorName = SampleData.alejandro.name
        let specialty = SampleData.alejandro.specialty

        do {
            _ = try await viewModel.createAppointmentFromUI(selectedDay: selectedDay,
                                                            selectedSlot: selectedSlot,
                                                            patientId: patientId,
                                                            patientName: patientName,
                                                            doctorName: doctorName,
                                                            specialty: specialty,
                                                            description: reason,
                                                            durationMinutes: durationMinutes)
            withAnimation { /* viewModel.saved is true */ }
        } catch {
            // Validation errors are exposed via viewModel fields; for unexpected errors show generic message
            if viewModel.errorMessage == nil {
                viewModel.errorMessage = String(describing: error)
            }
        }
    }
}

#Preview {
    NavigationStack { NewAppointmentView() }
}

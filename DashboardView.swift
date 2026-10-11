//
//  DashboardView.swift
//  GestorCitas
//
//  Pantalla 1 — Dashboard "Citas": saludo, métricas, filtros y lista de citas.
//

import SwiftUI

struct DashboardView: View {
    @State private var period: PeriodFilter = .hoy
    @State private var filter: QuickFilter = .todas
    @State private var viewMode: ViewMode = .lista
    @State private var searchText: String = ""

    enum ViewMode { case lista, agenda }

    private var appointments: [Appointment] { SampleData.dashboardAppointments }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                greetingSection
                searchSection
                metricsCarousel
                periodAndViewSection
                filterChipsSection
                appointmentsList
            }
            .padding(.horizontal, AppSpacing.marginSM)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, 96)
        }
        .background(AppColor.surface)
        .scrollIndicators(.hidden)
    }

    // MARK: Saludo + acción principal

    private var greetingSection: some View {
        HStack(alignment: .center, spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar").font(.system(size: 13, weight: .medium)).foregroundStyle(AppColor.primary)
                    Text("Jueves, 24 Octubre 2024").font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                }
                Text("Buenos días, Dra. Elena")
                    .font(AppFont.headlineLGMobile)
                    .foregroundStyle(AppColor.onSurface)
                Text("Tiene 18 citas programadas para hoy")
                    .font(AppFont.bodySM)
                    .foregroundStyle(AppColor.onSurfaceVariant)
            }
            Spacer()
            PrimaryButton(title: "Nueva Cita", icon: "plus", fullWidth: false) {}
        }
    }

    // MARK: Búsqueda + filtro

    private var searchSection: some View {
        HStack(spacing: AppSpacing.sm) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").font(.system(size: 15)).foregroundStyle(AppColor.onSurfaceVariant)
                TextField("Buscar paciente, DNI o médico...", text: $searchText)
                    .font(AppFont.bodyMD)
                    .foregroundStyle(AppColor.onSurface)
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(AppColor.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            .shadow(color: AppShadow.cardColor2, radius: 3, y: 1)

            IconButton(icon: "slider.horizontal.3", tint: AppColor.onSurfaceVariant, size: 44)
        }
    }

    // MARK: Métricas

    private var metricsCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                MetricCard(label: "Total", value: "18", caption: "Pacientes",
                           icon: "calendar", tint: AppColor.primary,
                           background: AppColor.surfaceContainerLowest,
                           iconBackground: AppColor.surfaceContainerHigh)
                MetricCard(label: "Confirmadas", value: "12", caption: "66% del total",
                           icon: "checkmark.circle", tint: AppColor.secondary,
                           background: AppColor.secondaryFixed.opacity(0.3),
                           iconBackground: AppColor.secondaryFixed)
                MetricCard(label: "En Espera", value: "4", caption: "Check-in pend.",
                           icon: "hourglass", tint: AppColor.amberDeep,
                           background: AppColor.amberSoft.opacity(0.5),
                           iconBackground: AppColor.amberSoft)
                MetricCard(label: "Canceladas", value: "2", caption: "Reagendadas",
                           icon: "xmark.circle", tint: AppColor.error,
                           background: AppColor.errorContainer.opacity(0.4),
                           iconBackground: AppColor.errorContainer)
            }
            .padding(.horizontal, AppSpacing.marginSM)
        }
        .padding(.horizontal, -AppSpacing.marginSM)
    }

    // MARK: Período + vista

    private var periodAndViewSection: some View {
        HStack {
            HStack(spacing: 2) {
                ForEach(PeriodFilter.allCases) { p in
                    PeriodPill(title: p.rawValue, isSelected: period == p) { period = p }
                }
            }
            .padding(4)
            .background(AppColor.surfaceContainerHigh.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))

            Spacer()

            HStack(spacing: 2) {
                viewToggleButton(icon: "list.bullet", mode: .lista)
                viewToggleButton(icon: "square.grid.2x2", mode: .agenda)
            }
            .padding(4)
            .background(AppColor.surfaceContainerHigh.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        }
    }

    private func viewToggleButton(icon: String, mode: ViewMode) -> some View {
        Button {
            viewMode = mode
        } label: {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(viewMode == mode ? AppColor.primary : AppColor.onSurfaceVariant)
                .frame(width: 30, height: 30)
                .background(viewMode == mode ? AppColor.surfaceContainerLowest : .clear)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: Chips de filtro

    private var filterChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(QuickFilter.allCases) { f in
                    SelectableChip(title: f.rawValue, isSelected: filter == f, style: .filled) {
                        filter = f
                    }
                }
            }
            .padding(.horizontal, AppSpacing.marginSM)
        }
        .padding(.horizontal, -AppSpacing.marginSM)
    }

    // MARK: Lista de citas

    private var appointmentsList: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(appointments) { appointment in
                AppointmentCard(appointment: appointment)
            }
        }
    }
}

// MARK: - Tarjeta de cita (Dashboard)

struct AppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Cabecera: hora + estado
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: appointment.modality == .telemedicina ? "video" : "clock")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(appointment.status.accent)
                    Text(appointment.timeRange)
                        .font(AppFont.labelLG)
                        .foregroundStyle(AppColor.onSurface)
                        .monospacedDigit()
                }
                Spacer()
                StatusBadge(status: appointment.status,
                            pulsing: appointment.status == .enConsulta)
            }

            // Paciente
            HStack(alignment: .top, spacing: 12) {
                AvatarView(name: appointment.patient.name, seed: appointment.patient.avatarSeed,
                           size: 48, cornerRadius: AppRadius.field)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(appointment.patient.name)
                            .font(AppFont.headlineMD)
                            .foregroundStyle(AppColor.onSurface)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.system(size: 15))
                            .foregroundStyle(AppColor.onSurfaceVariant)
                    }

                    HStack(spacing: 6) {
                        Text(appointment.patient.isChild
                             ? "\(appointment.patient.age) años (Pediatría)"
                             : "\(appointment.patient.age) años")
                        Text("•")
                        Text(appointment.patient.isChild
                             ? "Tutor: \(appointment.patient.tutor ?? "—")"
                             : "DNI \(appointment.patient.dni)")
                    }
                    .font(AppFont.bodySM)
                    .foregroundStyle(AppColor.onSurfaceVariant)

                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: specialtyIcon(appointment.doctor.specialty))
                                .font(.system(size: 13))
                            Text("\(appointment.doctor.specialty) • \(shortName(appointment.doctor.name))")
                        }
                        .font(AppFont.labelSM)
                        .foregroundStyle(appointment.status.accent)

                        HStack(spacing: 4) {
                            Image(systemName: appointment.modality.icon).font(.system(size: 12))
                            Text(modalityText)
                        }
                        .font(AppFont.labelSM)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(AppColor.surfaceContainerHigh.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                    }
                    .padding(.top, 2)
                }
            }

            // Acciones
            actionsRow
        }
        .padding(16)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
        .overlay(alignment: .leading) {
            // Acento lateral según estado
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(appointment.status.accent)
                .frame(width: 4)
                .padding(.vertical, 16)
                .padding(.leading, 0)
        }
        .shadow(color: AppShadow.cardColor, radius: 10, y: 3)
    }

    private var modalityText: String {
        switch appointment.modality {
        case .presencial: return "Presencial - \(appointment.doctor.room)"
        case .telemedicina: return "Telemedicina HD"
        }
    }

    @ViewBuilder
    private var actionsRow: some View {
        HStack(spacing: 8) {
            if appointment.modality == .telemedicina {
                HStack(spacing: 6) {
                    Circle().fill(AppColor.secondary).frame(width: 7, height: 7)
                    Text("Sala virtual abierta").font(AppFont.labelSM).foregroundStyle(AppColor.secondary)
                }
                Spacer()
                SoftButton(title: "Ficha médica", background: AppColor.surfaceContainerHigh.opacity(0.5)) {}
                PrimaryButton(title: "Iniciar llamada", icon: "video", color: AppColor.secondary) {}
            } else if appointment.status == .pendiente {
                Spacer()
                SoftButton(title: "Confirmar llegada", icon: "person.badge.plus",
                           tint: AppColor.amberDeep, background: AppColor.amberSoft) {}
                SoftButton(title: "Avisar a sala", icon: "message") {}
            } else if appointment.status == .enConsulta {
                Spacer()
                SoftButton(title: "Expediente", icon: "folder") {}
                SoftButton(title: "Recordatorio", icon: "bell.badge") {}
                IconButton(icon: "doc.text", tint: AppColor.primary, size: 32) {}
            } else {
                Spacer()
                SoftButton(title: "Historial", icon: "clock.arrow.circlepath") {}
                PrimaryButton(title: "Llamar paciente", icon: "play.fill") {}
            }
        }
    }

    private func specialtyIcon(_ specialty: String) -> String {
        switch specialty {
        case "Cardiología": return "heart"
        case "Dermatología": return "hand.raised"
        case "Pediatría": return "figure.child"
        case "Cirugía Gral.": return "scissors"
        case "Medicina Interna": return "stethoscope"
        default: return "stethoscope"
        }
    }

    private func shortName(_ name: String) -> String {
        // "Dra. Elena Morales" -> "Dra. E. Morales"
        let parts = name.split(separator: " ")
        guard parts.count >= 3 else { return name }
        let title = parts[0]
        let first = parts[1].first.map { String($0) + "." } ?? ""
        let last = parts.dropFirst(2).joined(separator: " ")
        return "\(title) \(first) \(last)"
    }
}

#Preview {
    DashboardView()
}

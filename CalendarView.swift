//
//  CalendarView.swift
//  GestorCitas
//
//  Pantalla 2 — Calendario y Agenda: cabecera de semana, especialistas,
//  timeline horario y resumen de ocupación.
//

import SwiftUI

struct CalendarView: View {
    @State private var viewTab: ViewTab = .dia
    @State private var selectedSpecialist: String = "Todos"
    @State private var drawerExpanded = true

    enum ViewTab { case dia, semana }

    private let weekDays: [(String, Int, Bool, Bool)] = [
        ("L", 14, false, false),
        ("M", 15, false, false),
        ("X", 16, true,  true),   // seleccionado, con citas
        ("J", 17, false, false),
        ("V", 18, false, false),
        ("S", 19, false, true),   // fin de semana (atenuado)
        ("D", 20, false, true),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                calendarHeader
                specialistsSelector
                agendaTimeline
                occupancyDrawer
            }
            .padding(.horizontal, AppSpacing.marginSM)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, 96)
        }
        .background(AppColor.surface)
        .scrollIndicators(.hidden)
    }

    // MARK: Cabecera de calendario

    private var calendarHeader: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar").font(.system(size: 18, weight: .medium)).foregroundStyle(AppColor.primary)
                    Text("Octubre 2024").font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                    Text("Semana 42")
                        .font(AppFont.labelSM)
                        .foregroundStyle(AppColor.primary)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(AppColor.surfaceContainer)
                        .clipShape(Capsule())
                }
                Spacer()
                HStack(spacing: 6) {
                    roundNavButton("chevron.left")
                    Button {} label: {
                        Text("Hoy").font(AppFont.labelSM).fontWeight(.semibold)
                            .foregroundStyle(AppColor.onPrimaryFixed)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(AppColor.primaryFixed)
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                    roundNavButton("chevron.right")
                }
            }

            // Toggle Día / Semana
            HStack(spacing: 0) {
                tabButton("Vista Día", icon: "calendar.day.timeline.left", tab: .dia)
                tabButton("Vista Semanal", icon: "calendar", tab: .semana)
            }
            .padding(4)
            .background(AppColor.surfaceContainerLow)
            .clipShape(Capsule())

            // Días de la semana
            HStack(spacing: 4) {
                ForEach(Array(weekDays.enumerated()), id: \.offset) { _, day in
                    dayColumn(day)
                }
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    private func roundNavButton(_ icon: String) -> some View {
        Button {} label: {
            Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColor.onSurfaceVariant)
                .frame(width: 30, height: 30)
                .background(AppColor.surfaceContainerLow)
                .clipShape(Circle())
        }.buttonStyle(.plain)
    }

    private func tabButton(_ title: String, icon: String, tab: ViewTab) -> some View {
        Button { viewTab = tab } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 13, weight: .medium))
                Text(title).font(AppFont.labelMD)
            }
            .foregroundStyle(viewTab == tab ? AppColor.primary : AppColor.onSurfaceVariant)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(viewTab == tab ? AppColor.surfaceContainerLowest : .clear)
            .clipShape(Capsule())
            .shadow(color: viewTab == tab ? AppShadow.cardColor2 : .clear, radius: 3, y: 1)
        }.buttonStyle(.plain)
    }

    private func dayColumn(_ day: (String, Int, Bool, Bool)) -> some View {
        let (label, number, isSelected, isWeekend) = day
        return VStack(spacing: 3) {
            Text(label).font(AppFont.labelSM)
                .foregroundStyle(isSelected ? AppColor.onPrimaryContainer : AppColor.onSurfaceVariant)
            Text("\(number)")
                .font(AppFont.headlineMD)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(isSelected ? AppColor.onPrimary : AppColor.onSurfaceVariant)
                .monospacedDigit()
            Circle()
                .fill(isSelected ? AppColor.secondaryContainer : (isWeekend ? .clear : AppColor.secondary))
                .frame(width: 4, height: 4)
                .opacity(isWeekend ? 0 : 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(isSelected ? AppColor.primaryContainer : .clear)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        .opacity(isWeekend ? 0.6 : 1)
    }

    // MARK: Selector de especialistas

    private var specialistsSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("ESPECIALISTAS")
                    .font(AppFont.labelSM).fontWeight(.semibold)
                    .foregroundStyle(AppColor.onSurfaceVariant)
                Spacer()
                Text("Filtrar equipo").font(AppFont.labelSM).foregroundStyle(AppColor.primary)
            }
            .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    specialistChip(name: "Todos", specialty: nil, seed: "all", selected: selectedSpecialist == "Todos") {
                        selectedSpecialist = "Todos"
                    }
                    ForEach(SampleData.specialists) { doc in
                        specialistChip(name: doc.name, specialty: doc.specialty, seed: doc.avatarSeed,
                                       selected: selectedSpecialist == doc.name, online: doc.isOnline) {
                            selectedSpecialist = doc.name
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.marginSM)
            }
            .padding(.horizontal, -AppSpacing.marginSM)
        }
    }

    private func specialistChip(name: String, specialty: String?, seed: String,
                                selected: Bool, online: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if name == "Todos" {
                    ZStack {
                        Circle().fill(selected ? AppColor.onPrimary.opacity(0.2) : AppColor.surfaceContainer)
                        Image(systemName: "person.3.fill").font(.system(size: 11))
                            .foregroundStyle(selected ? AppColor.onPrimary : AppColor.onSurfaceVariant)
                    }
                    .frame(width: 22, height: 22)
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        AvatarView(name: name, seed: seed, size: 22)
                        Circle()
                            .fill(online ? AppColor.secondary : AppColor.outline)
                            .frame(width: 7, height: 7)
                            .overlay(Circle().stroke(AppColor.surfaceContainerLowest, lineWidth: 1))
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(name)
                        .font(AppFont.labelMD)
                        .foregroundStyle(selected ? AppColor.onPrimary : AppColor.onSurface)
                        .lineLimit(1)
                    if let specialty {
                        Text(specialty).font(.system(size: 10)).foregroundStyle(AppColor.onSurfaceVariant)
                    }
                }
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(selected ? AppColor.primary : AppColor.surfaceContainerLowest)
            .clipShape(Capsule())
            .shadow(color: AppShadow.cardColor2, radius: 3, y: 1)
        }
        .buttonStyle(.plain)
    }

    // MARK: Timeline de agenda

    private var agendaTimeline: some View {
        VStack(spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Text("Miércoles, 16 Oct").font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                    Circle().fill(AppColor.secondary).frame(width: 6, height: 6)
                    Text("En tiempo real").font(AppFont.labelSM).fontWeight(.semibold).foregroundStyle(AppColor.secondary)
                }
                Spacer()
                Text("Franjas de 30 min").font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
            }
            .padding(.horizontal, 4)

            ForEach(SampleData.agendaItems) { item in
                AgendaRow(item: item)
            }
        }
    }

    // MARK: Drawer de ocupación

    private var occupancyDrawer: some View {
        VStack(spacing: 10) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { drawerExpanded.toggle() }
            } label: {
                HStack {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle().fill(AppColor.primaryFixed)
                            Image(systemName: "chart.line.uptrend.xyaxis").font(.system(size: 13)).foregroundStyle(AppColor.primary)
                        }.frame(width: 28, height: 28)
                        Text("Resumen de Ocupación Diaria").font(AppFont.labelMD).fontWeight(.semibold).foregroundStyle(AppColor.onSurface)
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        Text("85% Ocupado")
                            .font(AppFont.labelSM).fontWeight(.bold).foregroundStyle(AppColor.secondary)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(AppColor.secondaryFixed)
                            .clipShape(Capsule())
                        Image(systemName: drawerExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 13)).foregroundStyle(AppColor.outline)
                    }
                }
            }.buttonStyle(.plain)

            if drawerExpanded {
                HStack(spacing: 8) {
                    occupancyCell("Restantes", "7 Citas", AppColor.primary)
                    occupancyCell("Próxima", "10:00 AM", AppColor.secondary)
                    occupancyCell("Libres", "2 Slots", AppColor.onSurface)
                }
            }
        }
        .padding(12)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 10, y: 3)
    }

    private func occupancyCell(_ label: String, _ value: String, _ tint: Color) -> some View {
        VStack(spacing: 2) {
            Text(label).font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
            Text(value).font(AppFont.headlineMD).fontWeight(.bold).foregroundStyle(tint).monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(AppColor.surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
    }
}

// MARK: - Fila de agenda

struct AgendaRow: View {
    let item: AgendaItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Columna de hora
            VStack(spacing: 1) {
                Text(item.time)
                    .font(AppFont.labelSM).fontWeight(.semibold)
                    .foregroundStyle(timeColor)
                    .monospacedDigit()
                Text(item.meridiem)
                    .font(.system(size: 10)).foregroundStyle(AppColor.outline)
            }
            .frame(width: 48, alignment: .trailing)
            .padding(.top, 6)

            // Contenido
            content
        }
    }

    private var timeColor: Color {
        switch item {
        case .appointment(let a):
            return a.status == .confirmada ? AppColor.onSurface : AppColor.secondary
        case .free: return AppColor.onSurfaceVariant
        case .breakTime: return AppColor.outline
        }
    }

    @ViewBuilder
    private var content: some View {
        switch item {
        case .appointment(let a):
            appointmentCard(a)
        case .free(_, _, let title, let subtitle):
            freeSlotCard(title: title, subtitle: subtitle)
        case .breakTime(_, _, let title, let subtitle, let minutes):
            breakCard(title: title, subtitle: subtitle, minutes: minutes)
        }
    }

    private func appointmentCard(_ a: Appointment) -> some View {
        HStack(spacing: 0) {
            Rectangle().fill(accentFor(a)).frame(width: 5)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(a.startTime) - \(a.endTime) \(a.startMeridiem)")
                        .font(AppFont.labelSM).fontWeight(.semibold)
                        .foregroundStyle(accentFor(a))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(accentFor(a).opacity(0.12))
                        .clipShape(Capsule())
                    HStack(spacing: 4) {
                        Image(systemName: iconFor(a)).font(.system(size: 11))
                        Text(tagFor(a)).font(AppFont.labelSM)
                    }
                    .foregroundStyle(accentFor(a))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(accentFor(a).opacity(0.10))
                    .clipShape(Capsule())
                    Spacer()
                    if a.modality == .telemedicina {
                        PrimaryButton(title: "Iniciar", icon: "video", color: AppColor.secondary) {}
                    } else {
                        Image(systemName: "ellipsis").font(.system(size: 14)).foregroundStyle(AppColor.outline)
                    }
                }
                HStack(spacing: 10) {
                    AvatarView(name: a.patient.name, seed: a.patient.avatarSeed, size: 36)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(a.patient.name).font(AppFont.labelLG).fontWeight(.semibold).foregroundStyle(AppColor.onSurface).lineLimit(1)
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle").font(.system(size: 11)).foregroundStyle(AppColor.secondary)
                            Text("\(a.doctor.room) • \(a.doctor.name)")
                                .font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                        }
                    }
                    Spacer()
                    StatusBadge(status: a.status)
                }
            }
            .padding(12)
        }
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    private func freeSlotCard(title: String, subtitle: String) -> some View {
        HStack {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(AppColor.surfaceContainer)
                    Image(systemName: "calendar.badge.plus").font(.system(size: 15)).foregroundStyle(AppColor.primary)
                }.frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(AppFont.labelLG).foregroundStyle(AppColor.onSurface)
                    Text(subtitle).font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                }
            }
            Spacer()
            Button {} label: {
                Image(systemName: "plus").font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                    .frame(width: 30, height: 30)
                    .background(AppColor.primaryFixed)
                    .clipShape(Circle())
            }.buttonStyle(.plain)
        }
        .padding(12)
        .background(AppColor.surfaceContainerLowest.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor2, radius: 4, y: 1)
    }

    private func breakCard(title: String, subtitle: String, minutes: Int) -> some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(AppColor.surfaceContainerHighest)
                    Image(systemName: "cup.and.saucer").font(.system(size: 15)).foregroundStyle(AppColor.outline)
                }.frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(AppFont.labelMD).fontWeight(.semibold).foregroundStyle(AppColor.onSurfaceVariant)
                    Text(subtitle).font(AppFont.bodySM).foregroundStyle(AppColor.outline)
                }
            }
            Spacer()
            Text("\(minutes) min")
                .font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(AppColor.surfaceContainerHighest)
                .clipShape(Capsule())
        }
        .padding(12)
        .background(AppColor.surfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
    }

    private func accentFor(_ a: Appointment) -> Color {
        if a.reason == "Revisión post-operatoria" { return AppColor.tertiary }
        if a.reason == "Chequeo Anual" { return AppColor.secondaryFixedDim }
        switch a.modality {
        case .telemedicina: return AppColor.secondaryFixedDim
        case .presencial: return AppColor.primaryContainer
        }
    }

    private func iconFor(_ a: Appointment) -> String {
        if a.reason == "Revisión post-operatoria" { return "bandage" }
        if a.reason == "Chequeo Anual" { return "heart.text.square" }
        switch a.modality {
        case .telemedicina: return "video"
        case .presencial: return "stethoscope"
        }
    }

    private func tagFor(_ a: Appointment) -> String {
        if let reason = a.reason { return reason }
        return a.doctor.specialty
    }
}

#Preview {
    CalendarView()
}

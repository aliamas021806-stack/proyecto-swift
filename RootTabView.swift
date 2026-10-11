//
//  RootTabView.swift
//  GestorCitas
//
//  Contenedor principal con barra de navegación inferior flotante
//  (estilo glassmorphic) y las cinco secciones de la app.
//

import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case citas      = "Citas"
    case calendario = "Calendario"
    case pacientes  = "Pacientes"
    case medicos    = "Médicos"
    case ajustes    = "Ajustes"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .citas:      return "cross.case.fill"
        case .calendario: return "calendar"
        case .pacientes:  return "person.2.fill"
        case .medicos:    return "stethoscope"
        case .ajustes:    return "gearshape.fill"
        }
    }
}

struct RootTabView: View {
    @State private var selected: AppTab = .citas

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.surface.ignoresSafeArea()

            Group {
                switch selected {
                case .citas:
                    NavigationStack {
                        VStack(spacing: 0) {
                            AppHeader(subtitle: "Citas")
                            DashboardView()
                        }
                        .background(AppColor.surface)
                        .toolbar(.hidden, for: .navigationBar)
                    }
                case .calendario:
                    NavigationStack {
                        VStack(spacing: 0) {
                            AppHeader(subtitle: "Calendario")
                            CalendarView()
                        }
                        .background(AppColor.surface)
                        .toolbar(.hidden, for: .navigationBar)
                    }
                case .pacientes:
                    PlaceholderScreen(title: "Pacientes", icon: "person.2.fill",
                                      message: "Directorio de pacientes (pendiente de diseño).")
                case .medicos:
                    PlaceholderScreen(title: "Médicos", icon: "stethoscope",
                                      message: "Gestión de equipo médico (pendiente de diseño).")
                case .ajustes:
                    PlaceholderScreen(title: "Ajustes", icon: "gearshape.fill",
                                      message: "Configuración de la aplicación (pendiente de diseño).")
                }
            }

            FloatingTabBar(selected: $selected)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Barra flotante

struct FloatingTabBar: View {
    @Binding var selected: AppTab

    var body: some View {
        HStack {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) { selected = tab }
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 20, weight: selected == tab ? .semibold : .regular))
                        Text(tab.rawValue).font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selected == tab ? AppColor.primary : AppColor.onSurfaceVariant)
                    .frame(minWidth: 56, minHeight: 44)
                    .padding(.horizontal, 6)
                    .background(selected == tab ? AppColor.primaryFixed : .clear)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(AppColor.surfaceContainerLowest.opacity(0.9))
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(Capsule().stroke(AppColor.outlineVariant.opacity(0.4), lineWidth: 1))
        .shadow(color: AppShadow.floatingColor, radius: 18, y: 8)
        .padding(.horizontal, AppSpacing.marginSM)
        .padding(.bottom, 8)
    }
}

// MARK: - Pantalla placeholder

struct PlaceholderScreen: View {
    let title: String
    let icon: String
    let message: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeader(subtitle: title)
                Spacer()
                VStack(spacing: 12) {
                    ZStack {
                        Circle().fill(AppColor.surfaceContainer).frame(width: 88, height: 88)
                        Image(systemName: icon).font(.system(size: 34)).foregroundStyle(AppColor.primary)
                    }
                    Text(title).font(AppFont.headlineLG).foregroundStyle(AppColor.onSurface)
                    Text(message)
                        .font(AppFont.bodyMD).foregroundStyle(AppColor.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                Spacer()
                Spacer()
            }
            .background(AppColor.surface)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    RootTabView()
}

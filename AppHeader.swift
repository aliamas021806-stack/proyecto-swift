//
//  AppHeader.swift
//  GestorCitas
//
//  Cabecera superior estilo "glassmorphic": logo MediCare, badge de clínica,
//  subtítulo, notificaciones y perfil. Soporta modo con botón "Volver".
//

import SwiftUI

struct AppHeader: View {
    var subtitle: String = "Citas"
    var showsBack: Bool = false
    var title: String? = nil
    var onBack: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            if showsBack {
                Button { onBack?() } label: {
                    Image(systemName: "arrow.left").font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppColor.onSurface)
                        .frame(width: 40, height: 40)
                }.buttonStyle(.plain)

                if let title {
                    Text(title).font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface).lineLimit(1)
                }
                Spacer()
                profileButton
            } else {
                HStack(spacing: 8) {
                    MediCareLogo(size: 32)
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 6) {
                            Text("MediCare").font(AppFont.headlineMD).foregroundStyle(AppColor.primary)
                            HStack(spacing: 4) {
                                Circle().fill(AppColor.secondary).frame(width: 5, height: 5)
                                Text("Clínica Central").font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(AppColor.secondary)
                            }
                            .padding(.horizontal, 7).padding(.vertical, 2)
                            .background(AppColor.secondaryFixed.opacity(0.5))
                            .clipShape(Capsule())
                        }
                        Text(subtitle).font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                    }
                }
                Spacer()
                notificationButton
                profileButton
            }
        }
        .padding(.horizontal, AppSpacing.marginSM)
        .frame(height: 64)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) { Hairline() }
    }

    private var notificationButton: some View {
        Button {} label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell").font(.system(size: 20)).foregroundStyle(AppColor.onSurfaceVariant)
                    .frame(width: 40, height: 40)
                Circle().fill(AppColor.secondaryFixedDim).frame(width: 9, height: 9)
                    .overlay(Circle().stroke(AppColor.surfaceContainerLowest, lineWidth: 2))
                    .offset(x: -6, y: 6)
            }
        }.buttonStyle(.plain)
    }

    private var profileButton: some View {
        Button {} label: {
            AvatarView(name: "Elena Morales", seed: "elena", size: 32)
                .overlay(Circle().stroke(AppColor.primaryFixed, lineWidth: 2))
        }.buttonStyle(.plain)
    }
}

/// Logotipo MediCare: cruz médica azul/menta dentro de un cuadro redondeado.
struct MediCareLogo: View {
    var size: CGFloat = 32

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(AppColor.primaryFixed.opacity(0.7))
            // Cruz vertical
            RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                .fill(AppColor.primaryContainer)
                .frame(width: size * 0.16, height: size * 0.5)
            // Cruz horizontal
            RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                .fill(AppColor.secondary)
                .frame(width: size * 0.5, height: size * 0.16)
            Circle().fill(.white).frame(width: size * 0.1, height: size * 0.1)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: 0) {
        AppHeader(subtitle: "Citas")
        AppHeader(subtitle: "Calendario")
        AppHeader(showsBack: true, title: "Nueva Cita")
        Spacer()
    }
    .background(AppColor.surface)
}

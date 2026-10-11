//
//  Components.swift
//  GestorCitas
//
//  Componentes reutilizables del sistema "Clinical Soft Light".
//

import SwiftUI

// MARK: - Avatar

/// Avatar generado a partir de iniciales con color determinista por semilla.
struct AvatarView: View {
    let name: String
    var seed: String = ""
    var size: CGFloat = 48
    var cornerRadius: CGFloat? = nil       // nil => círculo
    var palette: [Color] = [AppColor.primary, AppColor.secondary, AppColor.tertiary, AppColor.primaryContainer]

    private var initials: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? "?"
        let last = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + last).uppercased()
    }

    private var color: Color {
        let key = seed.isEmpty ? name : seed
        let hash = abs(key.unicodeScalars.reduce(0) { ($0 &* 31) &+ Int($1.value) })
        return palette[hash % palette.count]
    }

    var body: some View {
        ZStack {
            color.opacity(0.18)
            Text(initials)
                .font(AppFont.jakarta(size * 0.36, .bold))
                .foregroundStyle(color)
        }
        .frame(width: size, height: size)
        .clipShape(
            cornerRadius == nil
            ? AnyShape(Circle())
            : AnyShape(RoundedRectangle(cornerRadius: cornerRadius!, style: .continuous))
        )
        .overlay(
            (cornerRadius == nil
             ? AnyShape(Circle())
             : AnyShape(RoundedRectangle(cornerRadius: cornerRadius!, style: .continuous)))
                .stroke(AppColor.outlineVariant.opacity(0.4), lineWidth: 1)
        )
    }
}

// MARK: - Badge de estado

struct StatusBadge: View {
    let status: AppointmentStatus
    var showDot: Bool = true
    var pulsing: Bool = false

    @State private var pulse = false

    var body: some View {
        HStack(spacing: 6) {
            if showDot {
                Circle()
                    .fill(status.dotColor)
                    .frame(width: 6, height: 6)
                    .opacity(pulsing && pulse ? 0.35 : 1)
            }
            Text(status.rawValue)
                .font(AppFont.labelSM)
        }
        .foregroundStyle(status.badgeText)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(status.badgeBackground)
        .clipShape(Capsule())
        .onAppear {
            guard pulsing else { return }
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

// MARK: - Botón principal / secundario / fantasma

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var color: Color = AppColor.primaryContainer
    var fullWidth: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).font(.system(size: 16, weight: .semibold)) }
                Text(title).font(AppFont.labelLG)
            }
            .foregroundStyle(AppColor.onPrimary)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct SoftButton: View {
    let title: String
    var icon: String? = nil
    var tint: Color = AppColor.onSurface
    var background: Color = AppColor.surfaceContainer
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon { Image(systemName: icon).font(.system(size: 14, weight: .medium)) }
                Text(title).font(AppFont.labelSM)
            }
            .foregroundStyle(tint)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Chip seleccionable (filtros / píldoras de fecha)

struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    var style: ChipStyle = .soft
    var action: () -> Void

    enum ChipStyle { case soft, filled }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.labelSM)
                .foregroundStyle(foreground)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(background)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var foreground: Color {
        if isSelected {
            return style == .filled ? AppColor.onPrimary : AppColor.primary
        }
        return AppColor.onSurfaceVariant
    }

    private var background: Color {
        if isSelected {
            return style == .filled ? AppColor.primary : AppColor.surfaceContainerLowest
        }
        return style == .filled ? AppColor.surfaceContainerLowest : AppColor.surfaceContainerLowest
    }
}

// MARK: - Píldora de fecha (Hoy / Mañana / Esta semana)

struct PeriodPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.labelSM)
                .foregroundStyle(isSelected ? AppColor.primary : AppColor.onSurfaceVariant)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? AppColor.surfaceContainerLowest : .clear)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                .shadow(color: isSelected ? AppShadow.cardColor2 : .clear, radius: 3, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tarjeta de métrica (carrusel pastel)

struct MetricCard: View {
    let label: String
    let value: String
    let caption: String
    let icon: String
    var tint: Color = AppColor.primary
    var background: Color = AppColor.surfaceContainerLowest
    var iconBackground: Color = AppColor.surfaceContainerHigh

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(label)
                    .font(AppFont.labelSM)
                    .foregroundStyle(tint == AppColor.primary ? AppColor.onSurfaceVariant : tint)
                    .fontWeight(.semibold)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                        .fill(iconBackground)
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(tint)
                }
                .frame(width: 28, height: 28)
            }
            Spacer(minLength: 8)
            Text(value)
                .font(AppFont.headlineXLMobile)
                .foregroundStyle(tint == AppColor.primary ? AppColor.onSurface : tint)
                .monospacedDigit()
            Text(caption)
                .font(AppFont.labelSM)
                .foregroundStyle((tint == AppColor.primary ? AppColor.onSurfaceVariant : tint).opacity(0.8))
        }
        .padding(12)
        .frame(width: 128, height: 104, alignment: .topLeading)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }
}

// MARK: - Fila de documento (expediente / recetas)

struct DocumentRow: View {
    let fileName: String
    let meta: String
    let icon: String
    var tint: Color = AppColor.primary
    var onPreview: () -> Void = {}
    var onDownload: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                    .fill(AppColor.surfaceContainerHighest)
                Image(systemName: icon).font(.system(size: 18)).foregroundStyle(tint)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(fileName).font(AppFont.labelMD).foregroundStyle(AppColor.onSurface).lineLimit(1)
                Text(meta).font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
            }
            Spacer()
            HStack(spacing: 4) {
                IconButton(icon: "eye", tint: AppColor.onSurface, action: onPreview)
                IconButton(icon: "arrow.down.to.line", tint: AppColor.primary, action: onDownload)
            }
        }
        .padding(12)
        .background(AppColor.surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
    }
}

// MARK: - Botón de icono

struct IconButton: View {
    let icon: String
    var tint: Color = AppColor.onSurfaceVariant
    var size: CGFloat = 36
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(tint)
                .frame(width: size, height: size)
                .background(AppColor.surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Interruptor (switch) de estilo clínico

struct ClinicalToggle: View {
    let icon: String
    let title: String
    let subtitle: String
    var iconTint: Color = AppColor.secondary
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 20)).foregroundStyle(iconTint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(AppFont.labelMD).foregroundStyle(AppColor.onSurface)
                Text(subtitle).font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppColor.secondary)
        }
        .padding(10)
        .background(AppColor.surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
    }
}

// MARK: - Encabezado de sección

struct SectionHeader: View {
    let title: String
    var icon: String? = nil
    var tint: Color = AppColor.primary
    var trailing: AnyView? = nil

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon).font(.system(size: 15, weight: .semibold)).foregroundStyle(tint)
                }
                Text(title)
                    .font(AppFont.headlineMD)
                    .foregroundStyle(AppColor.onSurface)
            }
            Spacer()
            if let trailing { trailing }
        }
    }
}

// NOTA: se usa el `AnyShape` nativo de SwiftUI (iOS 16+) para elegir
// dinámicamente entre formas (círculo o rectángulo redondeado) en AvatarView.

// MARK: - Divisor hairline

struct Hairline: View {
    var body: some View {
        Rectangle()
            .fill(AppColor.outlineVariant.opacity(0.5))
            .frame(height: 1)
    }
}

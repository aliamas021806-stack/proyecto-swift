//
//  Theme.swift
//  GestorCitas
//
//  Sistema de diseño "Clinical Soft Light" — traducido desde DESIGN.md de Stitch.
//  Paleta, tipografía, espaciado, radios y sombras.
//

import SwiftUI

// MARK: - Colores

extension Color {
    /// Inicializa un Color desde un hex RGB (0xRRGGBB) con opacidad opcional.
    init(hex: UInt32, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

/// Paleta de marca y superficies del sistema "Clinical Soft Light".
enum AppColor {
    // Superficies
    static let surface               = Color(hex: 0xF8F9FF)
    static let surfaceContainerLowest = Color(hex: 0xFFFFFF)
    static let surfaceContainerLow   = Color(hex: 0xEFF4FF)
    static let surfaceContainer      = Color(hex: 0xE5EEFF)
    static let surfaceContainerHigh  = Color(hex: 0xDCE9FF)
    static let surfaceContainerHighest = Color(hex: 0xD3E4FE)
    static let surfaceVariant        = Color(hex: 0xD3E4FE)

    // Texto
    static let onSurface             = Color(hex: 0x0B1C30)
    static let onSurfaceVariant      = Color(hex: 0x434655)
    static let outline               = Color(hex: 0x737686)
    static let outlineVariant        = Color(hex: 0xC3C6D7)

    // Primario (azul clínico)
    static let primary               = Color(hex: 0x004AC6)
    static let primaryContainer      = Color(hex: 0x2563EB)
    static let onPrimary             = Color(hex: 0xFFFFFF)
    static let primaryFixed          = Color(hex: 0xDBE1FF)
    static let primaryFixedDim       = Color(hex: 0xB4C5FF)
    static let onPrimaryFixed        = Color(hex: 0x00174B)
    static let onPrimaryFixedVariant = Color(hex: 0x003EA8)
    static let onPrimaryContainer    = Color(hex: 0xEEEFFF)

    // Secundario (menta)
    static let secondary             = Color(hex: 0x006C49)
    static let secondaryContainer    = Color(hex: 0x6CF8BB)
    static let onSecondary           = Color(hex: 0xFFFFFF)
    static let secondaryFixed        = Color(hex: 0x6FFBBE)
    static let secondaryFixedDim     = Color(hex: 0x4EDEA3)
    static let onSecondaryContainer  = Color(hex: 0x00714D)
    static let onSecondaryFixed      = Color(hex: 0x002113)

    // Terciario (índigo)
    static let tertiary              = Color(hex: 0x3E3FCC)
    static let tertiaryContainer     = Color(hex: 0x585BE6)
    static let tertiaryFixed         = Color(hex: 0xE1E0FF)
    static let tertiaryFixedDim      = Color(hex: 0xC0C1FF)
    static let onTertiaryFixed       = Color(hex: 0x07006C)
    static let onTertiaryFixedVariant = Color(hex: 0x2F2EBE)

    // Error (rosa)
    static let error                 = Color(hex: 0xBA1A1A)
    static let errorContainer        = Color(hex: 0xFFDAD6)
    static let onErrorContainer      = Color(hex: 0x93000A)

    // Acentos semánticos de estado (usados en badges y chips)
    static let amber                 = Color(hex: 0xF59E0B)
    static let amberSoft             = Color(hex: 0xFEF3C7)
    static let amberDeep             = Color(hex: 0x92400E)
    static let amberDark             = Color(hex: 0x78350F)

    // Estados "En Consulta" (azul enfocado)
    static let azureSoft             = Color(hex: 0xDBEAFE)
    static let azureDeep             = Color(hex: 0x1E40AF)
}

// MARK: - Tipografía

/// Escala tipográfica: Plus Jakarta Sans para títulos, Inter para cuerpo.
/// Usa `.system` con diseños redondeados/serif como fallback si las fuentes
/// no están registradas en el bundle.
enum AppFont {
    static func jakarta(_ size: CGFloat, _ weight: Font.Weight) -> Font {
        .custom("PlusJakartaSans", size: size).weight(weight)
    }

    static func inter(_ size: CGFloat, _ weight: Font.Weight) -> Font {
        .custom("Inter", size: size).weight(weight)
    }

    // Títulos
    static let headlineXL       = jakarta(32, .bold)
    static let headlineXLMobile = jakarta(26, .bold)
    static let headlineLG       = jakarta(24, .semibold)
    static let headlineLGMobile = jakarta(20, .semibold)
    static let headlineMD       = jakarta(18, .semibold)

    // Cuerpo
    static let bodyLG = inter(16, .regular)
    static let bodyMD = inter(14, .regular)
    static let bodySM = inter(12, .regular)

    // Etiquetas
    static let labelLG = inter(14, .semibold)
    static let labelMD = inter(12, .semibold)
    static let labelSM = inter(11, .medium)
}

// MARK: - Espaciado (grid base de 8pt)

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 40
    static let gutter: CGFloat = 24
    static let gutterSM: CGFloat = 16
    static let margin: CGFloat = 32
    static let marginSM: CGFloat = 16
}

// MARK: - Radios

enum AppRadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let `default`: CGFloat = 8
    static let card: CGFloat = 16       // rounded-2xl
    static let field: CGFloat = 12      // rounded-xl
    static let pill: CGFloat = 999
}

// MARK: - Sombras

enum AppShadow {
    /// Tarjeta en reposo: borde hairline + sombra tintada suave.
    static let cardColor   = Color(hex: 0x2563EB, opacity: 0.04)
    static let cardColor2  = Color(hex: 0x0F172A, opacity: 0.03)
    static let cardRadius: CGFloat = 20
    static let cardY: CGFloat = 4

    /// Sombra flotante para popovers / barras.
    static let floatingColor = Color(hex: 0x0F172A, opacity: 0.10)
}

extension View {
    /// Aplica el estilo de "tarjeta nivel 1" del sistema de diseño.
    func cardStyle(
        background: Color = AppColor.surfaceContainerLowest,
        radius: CGFloat = AppRadius.card,
        border: Color? = AppColor.outlineVariant.opacity(0.5)
    ) -> some View {
        self
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(border ?? .clear, lineWidth: 1)
            )
            .shadow(color: AppShadow.cardColor, radius: AppShadow.cardRadius, x: 0, y: AppShadow.cardY)
            .shadow(color: AppShadow.cardColor2, radius: 6, x: 0, y: 2)
    }
}

// MARK: - Números tabulares

extension Font {
    /// Fuerza figuras tabulares para alinear horas y fechas.
    var tabularNumbers: Font { self.monospacedDigit() }
}

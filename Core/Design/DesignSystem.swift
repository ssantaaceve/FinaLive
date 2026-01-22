//
//  DesignSystem.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Design System con identidad visual fintech premium DARK MODE
/// Estilo oscuro inspirado en Nubank - exclusivo, moderno y minimalista
enum AppColors {
    // MARK: - Primary Colors (Verde Fintech)
    
    /// Verde principal suave y vibrante - acciones principales
    static let primary = Color(red: 0.24, green: 0.73, blue: 0.56) // Verde fintech #3DBB8F
    
    /// Verde más profundo - acciones de acento
    static let accent = Color(red: 0.18, green: 0.64, blue: 0.48) // Verde profundo #2EA37A
    
    /// Verde suave para estados secundarios (opacidad para dark UI)
    static let primarySoft = Color(red: 0.24, green: 0.73, blue: 0.56).opacity(0.2)
    
    // MARK: - Background Colors (Dark Premium)
    
    /// Fondo principal - Gradiente elegante y sutil
    static let backgroundPrimary = Color.black // #000000 (mantiene compatibilidad)
    
    /// Fondo secundario - gris muy oscuro para secciones alternadas
    static let backgroundSecondary = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    
    // MARK: - Background Gradient Colors
    
    /// Color superior del gradiente - rojo muy oscuro
    static let gradientTop = Color(red: 0.145, green: 0.0, blue: 0.0) // #250000
    
    /// Color medio del gradiente - casi negro con toque azul
    static let gradientMiddle = Color(red: 0.0, green: 0.0, blue: 0.031) // #000008
    
    /// Color inferior del gradiente - verde azulado oscuro
    static let gradientBottom = Color(red: 0.0, green: 0.271, blue: 0.302) // #00454d
    
    // MARK: - Surface Colors (Cards Dark)
    
    /// Superficie principal - cards oscuras con elevación sutil
    static let surfacePrimary = Color(red: 0.11, green: 0.11, blue: 0.12) // Gris oscuro #1C1C1E
    
    /// Superficie elevada - para cards destacadas (ligeramente más clara)
    static let surfaceElevated = Color(red: 0.17, green: 0.17, blue: 0.18) // #2C2C2E
    
    // MARK: - Text Colors (White/Gray Hierarchy)
    
    /// Texto primario - BLANCO para títulos y contenido principal
    static let textPrimary = Color.white // #FFFFFF
    
    /// Texto secundario - gris claro para textos de apoyo
    static let textSecondary = Color(hex:"e5e5e5") // Gris claro #e5e5e5
    
    // MARK: - Utility Colors
    
    /// Bordes sutiles - gris oscuro muy sutil
    static let border = Color(red: 0.28, green: 0.28, blue: 0.30) // #48484A
    
    /// Estados deshabilitados - gris medio visible en dark UI
    static let disabled = Color(red: 0.40, green: 0.40, blue: 0.42) // #666668
    
    /// Success - verde fintech (coherente con paleta)
    static let success = Color(red: 0.24, green: 0.73, blue: 0.56) // #3DBB8F
    
    /// Warning - tono cálido suave visible en dark
    static let warning = Color(red: 1.0, green: 0.75, blue: 0.25) // Naranja claro #FFC040
    
    /// Error - rojo suave pero visible en dark UI
    static let error = Color(red: 1.0, green: 0.37, blue: 0.37) // Rojo claro #FF5F5F
    
    // MARK: - Legacy Support (mantener para compatibilidad)
    
    /// @deprecated Usar backgroundPrimary
    static var background: Color { backgroundPrimary }
    
    /// @deprecated Usar primarySoft
    static var secondary: Color { primarySoft }
}

/// Tipografía moderna y legible para fintech
enum AppFonts {
    static let title = Font.title
    static let title2 = Font.title2
    static let headline = Font.headline
    static let body = Font.body
    static let caption = Font.caption
}

/// Sistema de espaciado consistente
enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

// MARK: - Color Extension

extension Color {
    /// Inicializador para crear un Color desde un código hexadecimal
    /// - Parameter hex: String hexadecimal (con o sin #), ej: "e5e5e5" o "#e5e5e5"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//
//  DesignSystem.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Design System con identidad visual fintech premium
/// Paleta verde suave, moderna y cercana
enum AppColors {
    // MARK: - Primary Colors (Verde Fintech)
    
    /// Verde principal suave y vibrante - acciones principales
    static let primary = Color(red: 0.24, green: 0.73, blue: 0.56) // Verde suave #3DBB8F
    
    /// Verde más profundo - acciones de acento
    static let accent = Color(red: 0.18, green: 0.64, blue: 0.48) // Verde profundo #2EA37A
    
    /// Verde suave para estados secundarios
    static let primarySoft = Color(red: 0.24, green: 0.73, blue: 0.56).opacity(0.15)
    
    // MARK: - Background Colors
    
    /// Fondo principal - verde claro/gris verdoso (NO blanco puro)
    static let backgroundPrimary = Color(red: 0.97, green: 0.98, blue: 0.96) // Verde claro #F7FAF5
    
    /// Fondo secundario - para secciones alternadas
    static let backgroundSecondary = Color(red: 0.95, green: 0.97, blue: 0.94) // Verde grisáceo #F2F7F0
    
    // MARK: - Surface Colors (Cards)
    
    /// Superficie principal - cards blancas suaves con elevación
    static let surfacePrimary = Color.white
    
    /// Superficie elevada - para cards destacadas
    static let surfaceElevated = Color(red: 1.0, green: 1.0, blue: 1.0) // Blanco suave
    
    // MARK: - Text Colors
    
    /// Texto primario - gris muy oscuro para títulos
    static let textPrimary = Color(red: 0.15, green: 0.15, blue: 0.15) // Gris oscuro #262626
    
    /// Texto secundario - gris medio para textos de apoyo
    static let textSecondary = Color(red: 0.45, green: 0.45, blue: 0.45) // Gris medio #737373
    
    // MARK: - Utility Colors
    
    /// Bordes sutiles
    static let border = Color(red: 0.90, green: 0.90, blue: 0.90) // Gris claro #E6E6E6
    
    /// Estados deshabilitados
    static let disabled = Color(red: 0.75, green: 0.75, blue: 0.75) // Gris medio claro
    
    /// Success (mantiene verde, pero coherente con paleta)
    static let success = Color(red: 0.24, green: 0.73, blue: 0.56)
    
    /// Warning - tono cálido suave
    static let warning = Color(red: 0.98, green: 0.75, blue: 0.18) // Naranja suave
    
    /// Error - rojo suave (no agresivo)
    static let error = Color(red: 0.91, green: 0.30, blue: 0.30) // Rojo suave #E84D4D
    
    // MARK: - Legacy Support (mantener para compatibilidad temporal)
    
    /// @deprecated Usar backgroundPrimary
    static var background: Color { backgroundPrimary }
    
    /// @deprecated Usar primary
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

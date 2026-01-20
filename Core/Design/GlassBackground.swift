//
//  GlassBackground.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Componente reutilizable de fondo tipo Liquid Glass
/// Efecto glass nativo de iOS con desenfoque, brillo y profundidad
struct GlassBackground: View {
    let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = AppSpacing.md) {
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack {
            // Base: Material con blur nativo
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
            
            // Highlight superior sutil (reflejo de luz)
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.08), location: 0.0),
                            .init(color: Color.white.opacity(0.03), location: 0.3),
                            .init(color: Color.clear, location: 0.5),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Stroke luminoso con gradiente sutil
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.25), location: 0.0),
                            .init(color: Color.white.opacity(0.15), location: 0.3),
                            .init(color: AppColors.border.opacity(0.3), location: 0.7),
                            .init(color: AppColors.border.opacity(0.2), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }
    }
}

#Preview {
    ZStack {
        // Simular fondo con gradiente
        LinearGradient(
            colors: [
                Color.black,
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: AppSpacing.lg) {
            // Ejemplo 1: Card glass
            VStack {
                Text("Glass Card")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(AppSpacing.md)
            .background(GlassBackground(cornerRadius: AppSpacing.md))
            
            // Ejemplo 2: Row glass
            HStack {
                VStack(alignment: .leading) {
                    Text("Transaction")
                        .font(AppFonts.body)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Hoy, 14:30")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textPrimary)
                }
                Spacer()
                Text("$125.50")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.success)
            }
            .padding(AppSpacing.md)
            .background(GlassBackground(cornerRadius: AppSpacing.sm))
            
            // Ejemplo 3: Large card
            VStack(spacing: AppSpacing.md) {
                Text("Balance Card")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                Text("$15,420.50")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(AppSpacing.lg)
            .background(GlassBackground(cornerRadius: AppSpacing.lg))
        }
        .padding()
    }
}





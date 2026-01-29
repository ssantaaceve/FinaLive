//
//  GlassModuleContainer.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 29/1/2026.
//

import SwiftUI

/// Contenedor reutilizable con efecto "Liquid Glass"
/// Se usa para envolver módulos expandibles o campos de texto en los formularios de registro.
struct GlassModuleContainer: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.surfacePrimary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    AppColors.textPrimary.opacity(0.2),
                                    AppColors.textPrimary.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        }
    }
}

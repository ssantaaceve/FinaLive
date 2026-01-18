//
//  AppBackground.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Componente reutilizable para el fondo gradiente de la app
/// Aplica un gradiente vertical elegante y sutil compatible con Liquid Glass
struct AppBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                AppColors.gradientTop,
                AppColors.gradientMiddle,
                AppColors.gradientBottom
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    AppBackground()
}

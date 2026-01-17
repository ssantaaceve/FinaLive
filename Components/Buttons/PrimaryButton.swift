//
//  PrimaryButton.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Botón primario reutilizable con estilo moderno
/// Aplica principios de diseño de Apple (Liquid Glass) con efectos sutiles
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.md)
                        .fill(AppColors.primary.gradient)
                }
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Comenzar", action: {})
        PrimaryButton(title: "Guardar", action: {})
    }
    .padding()
}

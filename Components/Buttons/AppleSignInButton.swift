//
//  AppleSignInButton.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Botón de Sign in with Apple
/// Componente reutilizable que sigue las guías de diseño de Apple
struct AppleSignInButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "applelogo")
                    .font(.system(size: 18, weight: .medium))
                
                Text("Continuar con Apple")
                    .font(AppFonts.headline)
            }
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.md)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.md)
                            .strokeBorder(AppColors.border, lineWidth: 0.5)
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        AppleSignInButton(action: {})
    }
    .padding()
}

//
//  CardView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Card reutilizable con estilo moderno
/// Aplica principios de diseño Liquid Glass con materiales y efectos sutiles
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppSpacing.md)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.lg)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 4)
            }
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Balance Total")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textSecondary)
            Text("$1,234.56")
                .font(.system(size: 48, weight: .bold))
        }
    }
    .padding(AppSpacing.md)
}

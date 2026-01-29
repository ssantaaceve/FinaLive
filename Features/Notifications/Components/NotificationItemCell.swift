//
//  NotificationItemCell.swift
//  FinaLive
//
//  Created by FinaLive AI on 28/1/2026.
//

import SwiftUI

struct NotificationItemCell: View {
    let model: NotificationModel
    
    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            // Icono Circular
            ZStack {
                Circle()
                    .fill(model.type.color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: model.type.iconName)
                    .font(.system(size: 20))
                    .foregroundStyle(model.type.color)
            }
            
            // Contenido Texto
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(model.title)
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Spacer()
                    
                    if !model.isRead {
                        Circle()
                            .fill(AppColors.success)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(model.message)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(AppSpacing.md)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfacePrimary.opacity(0.6))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.border.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        NotificationItemCell(model: NotificationModel(
            type: .reward,
            title: "Bonus Ganado",
            message: "Has completado tu racha de 3 días.",
            date: Date(),
            isRead: false
        ))
        .padding()
    }
}

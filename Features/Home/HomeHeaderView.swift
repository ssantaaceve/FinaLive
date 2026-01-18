//
//  HomeHeaderView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Header personalizado para HomeView
/// Incluye avatar, saludo y notificaciones con estilo premium
struct HomeHeaderView: View {
    let userName: String
    let hasNotifications: Bool
    var onNotificationsTap: () -> Void = {}
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Avatar (Izquierda)
            avatarView
            
            // Saludo (Centro)
            greetingView
            
            // Notificaciones (Derecha)
            notificationsButton
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
    }
    
    // MARK: - View Components
    
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(AppColors.surfacePrimary)
                .frame(width: 40, height: 40)
            
            Circle()
                .strokeBorder(AppColors.primary, lineWidth: 2)
                .frame(width: 40, height: 40)
            
            Image(systemName: "person.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
        }
    }
    
    private var greetingView: some View {
        Text("Hola, \(userName) 👋")
            .font(AppFonts.headline)
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity)
    }
    
    private var notificationsButton: some View {
        Button(action: onNotificationsTap) {
            ZStack {
                Circle()
                    .fill(AppColors.surfacePrimary)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "bell.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.primary)
                
                if hasNotifications {
                    Circle()
                        .fill(AppColors.error)
                        .frame(width: 8, height: 8)
                        .offset(x: 12, y: -12)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 20) {
        HomeHeaderView(
            userName: "Sergio",
            hasNotifications: true,
            onNotificationsTap: {}
        )
        
        HomeHeaderView(
            userName: "María",
            hasNotifications: false,
            onNotificationsTap: {}
        )
    }
    .padding()
    .background(AppBackground())
}

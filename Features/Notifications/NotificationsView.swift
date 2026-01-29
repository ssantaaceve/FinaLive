//
//  NotificationsView.swift
//  FinaLive
//
//  Created by FinaLive AI on 28/1/2026.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var router: AppRouter
    @StateObject private var viewModel = NotificationsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo
            AppBackground()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: {
                         dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundStyle(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(AppColors.surfacePrimary.opacity(0.5))
                            )
                    }
                    
                    Text("Notificaciones")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.markAllAsRead()
                        }
                    }) {
                        Text("Leído")
                            .font(AppFonts.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(AppColors.primary.opacity(0.15))
                            )
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.md)
                
                // Content
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(AppColors.primary)
                    Spacer()
                } else if !viewModel.hasNotifications {
                    emptyState
                } else {
                    notificationList
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var notificationList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.lg) {
                ForEach(viewModel.sections) { section in
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(section.title)
                            .font(AppFonts.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        ForEach(section.items) { item in
                            NotificationItemCell(model: item)
                                .padding(.horizontal, AppSpacing.lg)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.markAsRead(id: item.id)
                                    }
                                }
                        }
                    }
                }
                
                // Bottom Padding
                Spacer().frame(height: 100)
            }
            .padding(.top, AppSpacing.sm)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.textSecondary.opacity(0.4))
            
            VStack(spacing: AppSpacing.xs) {
                Text("Todo tranquilo por aquí")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("No tienes nuevas notificaciones en este momento.")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    NotificationsView(router: AppRouter())
}

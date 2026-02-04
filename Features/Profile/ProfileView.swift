//
//  ProfileView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 28/1/2026.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var router: AppRouter
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showComingSoonAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) { // Reduced spacing
                    // 1. Header ID Card
                    headerIDCard
                    
                    // 2. Gamification Module
                    gamificationSection
                    
                    // 3. Rewards Card (New MVP)
                    FutureFeatureCard(
                        iconName: "gift.fill",
                        title: "Beneficios Exclusivos",
                        subtitle: "Gana premios por tu buen comportamiento."
                    ) {
                        viewModel.showRewardsAlert = true
                    }
                    
                    // 4. Budget Coming Soon
                    FutureFeatureCard(
                        iconName: "chart.pie.fill",
                        title: "Presupuesto Inteligente",
                        subtitle: "Controla tus topes de gastos."
                    ) {
                        showComingSoonAlert = true
                    }
                    
                    // 4. Settings List
                    settingsList
                    
                    // 5. Danger Zone
                    logoutButton
                        .padding(.top, 24)
                }
                .frame(maxWidth: .infinity)
                .padding(AppSpacing.md)
                .padding(.bottom, 140) // Critical bottom padding adjusted
            }
            .background(AppBackground())
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .alert("¡Próximamente!", isPresented: $showComingSoonAlert) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text("¡Estamos trabajando en ello! Muy pronto podrás definir límites inteligentes.")
            }
            .alert("¡Muy Pronto! 🎁", isPresented: $viewModel.showRewardsAlert) {
                Button("Genial", role: .cancel) { }
            } message: {
                Text("Estamos preparando un sistema de recompensas único para ti. ¡Mantente atento!")
            }
        }
    }
    
    // MARK: - Sections
    
    private var headerIDCard: some View {
        HStack(spacing: AppSpacing.md) {
            // Foto de perfil simulada
            ZStack {
                Circle()
                .fill(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60) // Reduced size 80->60
                
                Text(viewModel.userInitial)
                    .font(.system(size: 24, weight: .bold, design: .rounded)) // Reduced font
                    .foregroundStyle(.white)
            }
            .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Info Usuario
            VStack(alignment: .leading, spacing: 2) { // Tighter spacing
                Text(viewModel.userName)
                    .font(AppFonts.headline) // Title2 -> Headline
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(viewModel.userEmail)
                    .font(AppFonts.caption) // Subheadline -> Caption
                    .foregroundStyle(AppColors.textSecondary)
                
                // Badge
                Text(viewModel.memberSince)
                    .font(.system(size: 10, weight: .medium)) // Caption -> Smaller custom
                    .foregroundStyle(AppColors.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2) // Reduced padding
                    .background(
                        Capsule()
                            .fill(AppColors.primary.opacity(0.15))
                            .overlay(
                                Capsule().stroke(AppColors.primary.opacity(0.3), lineWidth: 0.5)
                            )
                    )
                    .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(AppSpacing.md) // Reduced padding lg->md
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.surfacePrimary.opacity(0.6))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            AppColors.border.opacity(0.5),
                            AppColors.border.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    private var gamificationSection: some View {
        VStack(spacing: AppSpacing.sm) { // Reduced spacing md->sm
            HStack {
                Text("Tu Nivel FinaLive")
                    .font(AppFonts.subheadline) // Headline -> Subheadline
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.caption)
                        .foregroundStyle(AppColors.warning)
                    
                    Text("\(viewModel.currentPoints) pts")
                        .font(AppFonts.caption) // Subheadline -> Caption
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.warning)
                }
            }
            
            // Progress Section
            VStack(spacing: 8) {
                HStack {
                    Text(viewModel.levelName)
                        .font(AppFonts.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                    
                    Spacer()
                    
                    Text("Siguiente Nivel")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                // Custom Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColors.surfaceElevated)
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primary, AppColors.accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * viewModel.progressToNextLevel, height: 8)
                            .shadow(color: AppColors.primary.opacity(0.5), radius: 4, x: 0, y: 0)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(AppSpacing.md)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfacePrimary.opacity(0.4))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.border.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var settingsList: some View {
        VStack(spacing: AppSpacing.sm) {
            GlassSettingRow(
                icon: "bell.fill",
                color: AppColors.primary,
                title: "Notificaciones",
                isOn: $viewModel.notificationsEnabled
            )
            
            // Botón de Prueba (Solo para Dev/MVP)
            Button(action: {
                NotificationManager.shared.scheduleTestNotification()
            }) {
                HStack(spacing: AppSpacing.md) {
                    ZStack {
                        Circle().fill(Color.blue.opacity(0.15)).frame(width: 36, height: 36)
                        Image(systemName: "play.fill").font(.system(size: 14)).foregroundStyle(.blue)
                    }
                    Text("Probar Notificación (5s)")
                        .font(AppFonts.body).foregroundStyle(AppColors.textPrimary)
                    Spacer()
                    Text("DEV").font(.caption2).fontWeight(.bold).padding(4).background(Color.blue.opacity(0.2)).cornerRadius(4)
                }
                .padding(AppSpacing.md)
                .background { RoundedRectangle(cornerRadius: 16).fill(AppColors.surfacePrimary.opacity(0.6)) }
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.border.opacity(0.3), lineWidth: 0.5))
            }
            .buttonStyle(.plain)
            
            GlassSettingRow(
                icon: "faceid",
                color: AppColors.accent,
                title: "Seguridad / FaceID",
                isOn: $viewModel.faceIDEnabled
            )
            
            NavigationLink(destination: CycleConfigView(viewModel: viewModel, router: router)) {
                GlassSettingRow(
                    icon: "calendar.badge.clock",
                    color: AppColors.success,
                    title: "Ciclo Financiero",
                    showChevron: true
                )
            }
            .buttonStyle(.plain) // Necesario para que no se tinten todos los elementos
            
            GlassSettingRow(
                icon: "doc.text.fill",
                color: AppColors.textSecondary,
                title: "Términos y Condiciones",
                showChevron: true
            )
        }

    }
    
    private var logoutButton: some View {
        Button(action: {
            viewModel.logout()
            withAnimation {
                router.navigateToAuth()
            }
        }) {
            Text("Cerrar Sesión")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.error)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.surfacePrimary.opacity(0.3))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.error.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - Components

struct GlassSettingRow: View {
    let icon: String
    let color: Color
    let title: String
    var isOn: Binding<Bool>? = nil
    var showChevron: Bool = false
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Icon Background
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)
            }
            
            Text(title)
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
            
            if let isOn = isOn {
                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .tint(AppColors.primary)
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            }
        }
        .padding(AppSpacing.md)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfacePrimary.opacity(0.6))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.border.opacity(0.3), lineWidth: 0.5)
        )
    }
}

struct FutureFeatureCard: View {
    let iconName: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(AppColors.warning.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 20))
                        .foregroundStyle(AppColors.warning)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Navigation Indicator usually for cards looks mostly clickable
                Image(systemName: "chevron.right")
                     .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            }
            .padding(AppSpacing.md)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surfacePrimary.opacity(0.6))
            }
            .overlay(alignment: .topTrailing) {
                Text("PRONTO")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.warning)
                    .clipShape(Capsule())
                    .padding([.top, .trailing], 12)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.warning.opacity(0.3), lineWidth: 1)
            )
            .opacity(0.8) // Leve opacidad general
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView(router: AppRouter())
}

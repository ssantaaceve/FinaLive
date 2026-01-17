//
//  OnboardingView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Vista de onboarding inicial de la aplicación
/// Muestra una introducción simple y permite navegar a la pantalla principal
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @ObservedObject var router: AppRouter
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo con gradiente sutil
                LinearGradient(
                    colors: [AppColors.background, AppColors.background.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    iconSection
                    
                    Spacer()
                        .frame(height: AppSpacing.lg + AppSpacing.md)
                    
                    contentSection
                    
                    Spacer()
                    
                    actionSection
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + AppSpacing.lg)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var iconSection: some View {
        Image(systemName: "dollarsign.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .foregroundStyle(AppColors.primary.gradient)
            .shadow(color: AppColors.primary.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private var contentSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("Bienvenido a FinaLive")
                .font(AppFonts.title)
            
            Text("Gestiona tus finanzas de manera simple")
                .font(AppFonts.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.lg)
        }
    }
    
    private var actionSection: some View {
        PrimaryButton(title: "Comenzar") {
            viewModel.completeOnboarding()
            router.navigateToHome()
        }
    }
}

#Preview {
    OnboardingView(router: AppRouter())
}

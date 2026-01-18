//
//  OnboardingView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Vista principal de onboarding con navegación tipo pager
/// Contiene 3 pasos para configurar objetivos, metas e incentivos
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @ObservedObject var router: AppRouter
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo gradiente
                AppBackground()
                
                VStack(spacing: 0) {
                    // Pager con las 3 pantallas
                    TabView(selection: $viewModel.currentStep) {
                        OnboardingStep1View(viewModel: viewModel)
                            .tag(0)
                        
                        OnboardingStep2View(viewModel: viewModel)
                            .tag(1)
                        
                        OnboardingStep3View(viewModel: viewModel)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                    
                    // Botones de navegación
                    VStack(spacing: 0) {
                        // Separador sutil
                        Rectangle()
                            .fill(AppColors.border.opacity(0.2))
                            .frame(height: 0.5)
                        
                        navigationSection
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.lg)
                            .padding(.bottom, geometry.safeAreaInsets.bottom + AppSpacing.lg)
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var navigationSection: some View {
        HStack(spacing: AppSpacing.md) {
            // Botón Atrás
            if viewModel.currentStep > 0 {
                Button(action: {
                    viewModel.previousStep()
                }) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "chevron.left")
                        Text("Atrás")
                            .font(AppFonts.body)
                    }
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background {
                        RoundedRectangle(cornerRadius: AppSpacing.md)
                            .fill(AppColors.surfacePrimary)
                            .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.md)
                                .strokeBorder(AppColors.border, lineWidth: 1)
                            }
                    }
                }
                .buttonStyle(.plain)
            }
            
            // Botón Siguiente / Completar
            PrimaryButton(
                title: viewModel.currentStep == viewModel.totalSteps - 1 ? "Completar" : "Siguiente"
            ) {
                if viewModel.currentStep == viewModel.totalSteps - 1 {
                    viewModel.completeOnboarding()
                    router.navigateToHome()
                } else {
                    viewModel.nextStep()
                }
            }
            .disabled(!viewModel.canGoToNextStep)
            .opacity(viewModel.canGoToNextStep ? 1.0 : 0.5)
        }
    }
}

#Preview {
    OnboardingView(router: AppRouter())
}

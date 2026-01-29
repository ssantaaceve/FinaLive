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
                // Background
                AppBackground() // Uses the GlassBackground component
                
                VStack(spacing: 0) {
                    // Pager
                    TabView(selection: $viewModel.currentStep) {
                        OnboardingStep1View(viewModel: viewModel)
                            .tag(0)
                        
                        OnboardingStep2View(viewModel: viewModel)
                            .tag(1)
                        
                        OnboardingStep3View(viewModel: viewModel)
                            .tag(2)
                        
                        OnboardingInterestsView(viewModel: viewModel)
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                    
                    // Indicators & Navigation
                    VStack(spacing: AppSpacing.lg) {
                        // Page Indicators
                        HStack(spacing: 8) {
                            ForEach(0..<viewModel.totalSteps, id: \.self) { index in
                                Capsule()
                                    .fill(index == viewModel.currentStep ? AppColors.primary : AppColors.border)
                                    .frame(width: index == viewModel.currentStep ? 24 : 8, height: 8)
                                    .animation(.spring(), value: viewModel.currentStep)
                            }
                        }
                        
                        navigationSection
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + AppSpacing.lg)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var navigationSection: some View {
        HStack(spacing: AppSpacing.md) {
            // Back Button (Hidden on first step)
            if viewModel.currentStep > 0 {
                Button(action: {
                    viewModel.previousStep()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 50, height: 50)
                        .background {
                            Circle()
                                .fill(AppColors.surfacePrimary)
                                .overlay(Circle().stroke(AppColors.border, lineWidth: 1))
                        }
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            // Next / Complete Button
            PrimaryButton(
                title: viewModel.currentStep == viewModel.totalSteps - 1 ? "Comenzar Aventura" : "Siguiente"
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

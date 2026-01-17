//
//  OnboardingStep3View.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Pantalla 3: Selección de incentivos
struct OnboardingStep3View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            headerSection
            
            incentivesList
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("¿Te motivaría más ahorrar si recibes beneficios por cumplir tu meta?")
                .font(AppFonts.title2)
                .multilineTextAlignment(.center)
                .padding(.top, AppSpacing.xl)
        }
    }
    
    private var incentivesList: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(OnboardingViewModel.Incentive.allCases, id: \.self) { incentive in
                IncentiveCard(
                    incentive: incentive,
                    isSelected: viewModel.selectedIncentive == incentive
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.selectedIncentive = incentive
                    }
                }
            }
        }
    }
}

// MARK: - Incentive Card Component

struct IncentiveCard: View {
    let incentive: OnboardingViewModel.Incentive
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: incentive.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : AppColors.primary)
                    .frame(width: 24)
                
                Text(incentive.rawValue)
                    .font(AppFonts.body)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                        .font(.title3)
                }
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.md)
                    .fill(isSelected ? AppColors.primary.gradient : .ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.md)
                            .strokeBorder(
                                isSelected ? .clear : .quaternary,
                                lineWidth: isSelected ? 0 : 0.5
                            )
                    }
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingStep3View(viewModel: OnboardingViewModel())
        .padding()
}

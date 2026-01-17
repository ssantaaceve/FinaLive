//
//  OnboardingStep1View.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Pantalla 1: Selección de objetivo de ahorro
struct OnboardingStep1View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            headerSection
            
            goalsGrid
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("¿Para qué te gustaría ahorrar primero?")
                .font(AppFonts.title2)
                .multilineTextAlignment(.center)
                .padding(.top, AppSpacing.xl)
        }
    }
    
    private var goalsGrid: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            ForEach(OnboardingViewModel.SavingsGoal.allCases, id: \.self) { goal in
                GoalCard(
                    goal: goal,
                    isSelected: viewModel.selectedGoal == goal
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.selectedGoal = goal
                    }
                }
            }
        }
    }
}

// MARK: - Goal Card Component

struct GoalCard: View {
    let goal: OnboardingViewModel.SavingsGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.md) {
                Image(systemName: goal.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(isSelected ? .white : AppColors.primary)
                    .frame(height: 40)
                
                Text(goal.rawValue)
                    .font(AppFonts.caption)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(AppSpacing.md)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.md)
                    .fill(isSelected ? AnyShapeStyle(AppColors.primary.gradient) : AnyShapeStyle(.ultraThinMaterial))
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.md)
                            .strokeBorder(
                                isSelected ? AnyShapeStyle(.clear) : AnyShapeStyle(.quaternary),
                                lineWidth: isSelected ? 0 : 0.5
                            )
                    }
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? AppColors.primary.opacity(0.3) : .clear,
                radius: isSelected ? 8 : 0,
                x: 0,
                y: isSelected ? 4 : 0
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingStep1View(viewModel: OnboardingViewModel())
        .padding()
}

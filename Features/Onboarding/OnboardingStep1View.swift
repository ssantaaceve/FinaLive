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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    VStack(spacing: AppSpacing.xl) {
                        headerSection
                        
                        goalsGrid
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("¿Para qué te gustaría ahorrar primero?")
                .font(AppFonts.title2)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var goalsGrid: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            ForEach(OnboardingViewModel.SavingsGoal.allCases, id: \.self) { goal in
                let isOtherEditing = goal == .other && viewModel.selectedGoal == .other
                
                GoalCard(
                    goal: goal,
                    isSelected: viewModel.selectedGoal == goal,
                    customText: $viewModel.customGoalText
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if viewModel.selectedGoal == goal {
                            viewModel.selectedGoal = nil
                            viewModel.customGoalText = ""
                        } else {
                            viewModel.selectedGoal = goal
                            if goal != .other {
                                viewModel.customGoalText = ""
                            }
                        }
                    }
                }
                .gridCellColumns(isOtherEditing ? 2 : 1)
            }
        }
    }
}

// MARK: - Goal Card Component

struct GoalCard: View {
    let goal: OnboardingViewModel.SavingsGoal
    let isSelected: Bool
    @Binding var customText: String
    let action: () -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    
    private var showTextField: Bool {
        goal == .other && isSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Contenido principal: Card normal o TextField
            if showTextField {
                textFieldView
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            } else {
                buttonContentView
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showTextField)
    }
    
    // MARK: - View Components
    
    private var buttonContentView: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.md) {
                Image(systemName: goal.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(isSelected ? .white : AppColors.primary)
                    .frame(height: 40)
                
                Text(goal.rawValue)
                    .font(AppFonts.caption)
                    .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
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
                                isSelected ? AnyShapeStyle(.clear) : AnyShapeStyle(AppColors.border),
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
    
    private var textFieldView: some View {
        HStack(spacing: AppSpacing.md) {
            // Ícono a la izquierda
            Image(systemName: goal.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 32)
            
            // TextField integrado
            TextField("Escribe para qué ahorras", text: $customText)
                .font(AppFonts.body)
                .foregroundStyle(.white)
                .tint(.white)
                .multilineTextAlignment(.leading)
                .focused($isTextFieldFocused)
                .onAppear {
                    // Auto-focus cuando aparece el TextField
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isTextFieldFocused = true
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(.horizontal, AppSpacing.md)
        .background {
            RoundedRectangle(cornerRadius: AppSpacing.md)
                .fill(AnyShapeStyle(AppColors.primary.gradient))
        }
        .shadow(
            color: AppColors.primary.opacity(0.3),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    OnboardingStep1View(viewModel: OnboardingViewModel())
        .padding()
}

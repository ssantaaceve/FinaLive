//
//  OnboardingStep2View.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Pantalla 2: Meta de ahorro con rangos predefinidos
struct OnboardingStep2View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.15)
                    
                    VStack(spacing: AppSpacing.xl) {
                        headerSection
                        
                        amountRangesList
                        
                        footerNote
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.15)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("¿Cuánto te gustaría ahorrar para ese objetivo?")
                .font(AppFonts.title2)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var amountRangesList: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(OnboardingViewModel.AmountRange.allCases, id: \.self) { range in
                AmountRangeCard(
                    range: range,
                    isSelected: viewModel.selectedAmountRange == range
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.selectedAmountRange = range
                    }
                }
            }
        }
    }
    
    private var footerNote: some View {
            Text("Puedes cambiar esta meta en cualquier momento")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.top, AppSpacing.md)
    }
}

// MARK: - Amount Range Card Component

struct AmountRangeCard: View {
    let range: OnboardingViewModel.AmountRange
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Text(range.rawValue)
                    .font(AppFonts.headline)
                    .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
                
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
                    .fill(isSelected ? AnyShapeStyle(AppColors.primary.gradient) : AnyShapeStyle(.ultraThinMaterial))
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.md)
                            .strokeBorder(
                                isSelected ? AnyShapeStyle(.clear) : AnyShapeStyle(AppColors.border),
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
    OnboardingStep2View(viewModel: OnboardingViewModel())
        .padding()
}

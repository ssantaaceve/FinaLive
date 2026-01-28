//
//  OnboardingStep2View.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

struct OnboardingStep2View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            // Illustration Placeholder (Glass Effect)
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 40)
                    .offset(x: 20, y: 20)
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(Material.thinMaterial)
                    .frame(width: 220, height: 140)
                    .rotationEffect(.degrees(-5))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .overlay {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.textSecondary.opacity(0.3))
                                .frame(width: 100, height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.primary)
                                .frame(width: 140, height: 12)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<5) { _ in
                                    Circle()
                                        .fill(AppColors.border)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }
                
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.primary)
                    .background {
                        Circle()
                            .fill(Color.white)
                    }
                    .shadow(radius: 10)
                    .offset(x: 80, y: 60)
            }
            .frame(height: 350)
            
            // Content
            VStack(spacing: AppSpacing.md) {
                Text("Visualización Clara")
                    .font(AppFonts.title.bold())
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("Entiende en qué se va tu dinero.\nGráficos intuitivos y reportes detallados.")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        OnboardingStep2View(viewModel: OnboardingViewModel())
    }
}

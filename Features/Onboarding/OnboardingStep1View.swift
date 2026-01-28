//
//  OnboardingStep1View.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

struct OnboardingStep1View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            // Illustration Placeholder (Glass Effect)
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.2))
                    .frame(width: 280, height: 280)
                    .blur(radius: 30)
                
                Circle()
                    .fill(AppColors.accent.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .blur(radius: 20)
                    .offset(x: -40, y: -40)
                
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Material.thickMaterial)
                    .shadow(color: AppColors.primary.opacity(0.5), radius: 20)
                    .overlay {
                        Image(systemName: "chart.pie.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppColors.primary, AppColors.accent],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .mask {
                                Image(systemName: "chart.pie.fill")
                                    .font(.system(size: 80))
                            }
                    }
            }
            .frame(height: 350)
            
            // Content
            VStack(spacing: AppSpacing.md) {
                Text("Control Total")
                    .font(AppFonts.title.bold())
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("Toma el mando de tus finanzas personales.\nRegistra ingresos y gastos de forma sencilla.")
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
        OnboardingStep1View(viewModel: OnboardingViewModel())
    }
}

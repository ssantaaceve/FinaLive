//
//  OnboardingStep3View.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

struct OnboardingStep3View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            // Illustration Placeholder (Glass Effect)
            ZStack {
                Circle()
                    .fill(AppColors.warning.opacity(0.2))
                    .frame(width: 260, height: 260)
                    .blur(radius: 50)
                
                Image(systemName: "gift.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.warning, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: AppColors.warning.opacity(0.5), radius: 20)
                    .offset(y: -10)
                
                ForEach(0..<3) { i in
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundStyle(Color.yellow)
                        .offset(
                            x: CGFloat(i * 60 - 60),
                            y: CGFloat(-120 + abs(i - 1) * -30)
                        )
                        .shadow(color: Color.yellow.opacity(0.6), radius: 5)
                }
            }
            .frame(height: 350)
            
            // Content
            VStack(spacing: AppSpacing.md) {
                Text("Gana Premios")
                    .font(AppFonts.title.bold())
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("Cumple tus metas de registro y obtén beneficios exclusivos, descuentos y regalos.")
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
        OnboardingStep3View(viewModel: OnboardingViewModel())
    }
}

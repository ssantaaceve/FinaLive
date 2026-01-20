//
//  BalanceCardView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Card de balance con toggle de visibilidad y variación porcentual
/// Estilo premium glass/liquid glass con gradiente decorativo
struct BalanceCardView: View {
    let balance: Double
    let formattedBalance: String
    let percentageChange: String
    let income: Double
    let formattedIncome: String
    let expense: Double
    let formattedExpense: String
    
    @State private var showBalance: Bool = true
    
    var body: some View {
        ZStack {
            // Gradiente decorativo sutil
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.primary.opacity(0.3),
                            AppColors.primary.opacity(0.0)
                        ],
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: 160
                    )
                )
                .frame(width: 160, height: 160)
                .offset(x: 80, y: -80)
                .blur(radius: 40)
            
            VStack(spacing: AppSpacing.md) {
                // Header con label y toggle
                HStack {
                    Text("Balance Total")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showBalance.toggle()
                        }
                    }) {
                        Image(systemName: showBalance ? "eye.fill" : "eye.slash.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(AppSpacing.xs)
                            .background {
                                RoundedRectangle(cornerRadius: AppSpacing.sm)
                                    .fill(AppColors.surfacePrimary.opacity(0.5))
                            }
                    }
                    .buttonStyle(.plain)
                }
                
                // Balance (principal)
                Text(showBalance ? formattedBalance : "••••••")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentTransition(.opacity)
                
                // Variación porcentual
                if showBalance {
                    Text(percentageChange)
                        .font(AppFonts.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.success)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Separador sutil
                Rectangle()
                    .fill(AppColors.border.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.vertical, AppSpacing.xs)
                
                // Ingresos y Gastos
                incomeExpenseSection
            }
            .padding(AppSpacing.md)
        }
        .background {
            RoundedRectangle(cornerRadius: AppSpacing.lg)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: AppSpacing.lg)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    AppColors.border.opacity(0.2),
                                    AppColors.border.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                }
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
        }
    }
    
    // MARK: - View Components
    
    private var incomeExpenseSection: some View {
        HStack(spacing: AppSpacing.md) {
            incomeModule
            expenseModule
        }
    }
    
    private var incomeModule: some View {
        VStack(spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.success)
                
                Text("Ingresos")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Text(showBalance ? formattedIncome : "••••")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
                .contentTransition(.opacity)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var expenseModule: some View {
        VStack(spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.error)
                
                Text("Gastos")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Text(showBalance ? formattedExpense : "••••")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
                .contentTransition(.opacity)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BalanceCardView(
        balance: 15420.50,
        formattedBalance: "$15,420.50",
        percentageChange: "+2.5% vs mes anterior",
        income: 2500.00,
        formattedIncome: "$2,500.00",
        expense: 1249.50,
        formattedExpense: "$1,249.50"
    )
    .padding()
    .background(AppBackground())
}

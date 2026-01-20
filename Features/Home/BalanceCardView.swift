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
    @State private var selectedPeriod: Period = .month
    
    enum Period: String, CaseIterable {
        case today = "Hoy"
        case week = "Semana"
        case month = "Mes"
        case year = "Año"
    }
    
    var body: some View {
        ZStack {
            // Gradiente decorativo sutil (reducido)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.primary.opacity(0.15),
                            AppColors.primary.opacity(0.0)
                        ],
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 120, height: 120)
                .offset(x: 60, y: -60)
                .blur(radius: 30)
            
            VStack(spacing: AppSpacing.sm) {
                // Header con label y toggle
                HStack {
                    Text("Balance Total")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showBalance.toggle()
                        }
                    }) {
                        Image(systemName: showBalance ? "eye.fill" : "eye.slash.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary.opacity(0.8))
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                }
                
                // Selector de período (discreto)
                periodSelector
                
                // Balance (principal - reducido)
                Text(showBalance ? formattedBalance : "••••••")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentTransition(.opacity)
                
                // Variación porcentual (aumentado)
                if showBalance {
                    Text(percentageChange)
                        .font(AppFonts.body)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.success)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
                
                // Ingresos y Gastos (mini cards)
                incomeExpenseSection
            }
            .padding(AppSpacing.sm)
        }
    }
    // MARK: - View Components
    
    private var periodSelector: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(Period.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(
                            selectedPeriod == period
                                ? AppColors.textPrimary
                                : AppColors.textSecondary
                        )
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xs)
                        .background {
                            if selectedPeriod == period {
                                Capsule()
                                    .fill(AppColors.primary.opacity(0.2))
                                    .overlay {
                                        Capsule()
                                            .strokeBorder(AppColors.primary.opacity(0.4), lineWidth: 0.5)
                                    }
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var incomeExpenseSection: some View {
        HStack(spacing: AppSpacing.sm) {
            incomeModule
            expenseModule
        }
    }
    
    private var incomeModule: some View {
        VStack(spacing: AppSpacing.xs) {
            // Título (con más aire respecto a los bordes)
            Text("Ingresos")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            // Bloque compacto: ícono + monto (centrado visualmente)
            HStack(spacing: AppSpacing.xs) {
                // Ícono dentro de círculo translúcido
                ZStack {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(AppColors.success)
                }
                
                // Monto (formando bloque con ícono)
                Text(showBalance ? formattedIncome : "••••")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                    .contentTransition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .padding(.horizontal, AppSpacing.sm)
        .frame(minHeight: 60)
        .overlay {
            RoundedRectangle(cornerRadius: AppSpacing.md)
                .strokeBorder(AppColors.success.opacity(0.9), lineWidth: 1)
        }
    }
    
    private var expenseModule: some View {
        VStack(spacing: AppSpacing.xs) {
            // Título (con más aire respecto a los bordes)
            Text("Gastos")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            // Bloque compacto: ícono + monto (centrado visualmente)
            HStack(spacing: AppSpacing.xs) {
                // Ícono dentro de círculo translúcido
                ZStack {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(AppColors.error)
                }
                
                // Monto (formando bloque con ícono)
                Text(showBalance ? formattedExpense : "••••")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                    .contentTransition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .padding(.horizontal, AppSpacing.sm)
        .frame(minHeight: 60)
        .overlay {
            RoundedRectangle(cornerRadius: AppSpacing.md)
                .strokeBorder(AppColors.error.opacity(0.9), lineWidth: 1)
        }
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

//
//  GoalsProgressCardView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Card de seguimiento de metas con barras de progreso
/// Estilo premium glass con diseño tipo dashboard financiero
struct GoalsProgressCardView: View {
    let goals: [Goal]
    
    struct Goal: Identifiable {
        let id = UUID()
        let name: String
        let currentAmount: Double
        let targetAmount: Double
        
        var progress: Double {
            min(1.0, max(0.0, currentAmount / targetAmount))
        }
        
        var formattedCurrent: String {
            formatCurrency(currentAmount)
        }
        
        var formattedTarget: String {
            formatCurrency(targetAmount)
        }
        
        private func formatCurrency(_ amount: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
        }
    }
    
    var body: some View {
        Group {
            if !goals.isEmpty {
                VStack(spacing: AppSpacing.md) {
                    // Header
                    headerSection
                    
                    // Lista de metas
                    goalsList
                }
                .padding(AppSpacing.md)
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
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack(spacing: AppSpacing.sm) {
            // Ícono dentro de círculo translúcido
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "target")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }
            
            Text("Seguimiento de Metas")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
        }
    }
    
    private var goalsList: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(goals) { goal in
                goalRow(goal: goal)
            }
        }
    }
    
    private func goalRow(goal: Goal) -> some View {
        VStack(spacing: AppSpacing.sm) {
            // Nombre y porcentaje
            HStack {
                Text(goal.name)
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(Int(goal.progress * 100))%")
                    .font(AppFonts.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
            }
            
            // Barra de progreso
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Fondo de la barra
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.surfacePrimary.opacity(0.5))
                        .frame(height: 6)
                    
                    // Barra de progreso con gradiente
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.primary,
                                    AppColors.accent
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * goal.progress, height: 6)
                        .animation(.easeOut(duration: 0.3), value: goal.progress)
                }
            }
            .frame(height: 6)
            
            // Texto actual vs objetivo
            HStack {
                Text(goal.formattedCurrent)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
                
                Text("de")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary.opacity(0.6))
                
                Text(goal.formattedTarget)
                    .font(AppFonts.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
            }
        }
        .padding(AppSpacing.sm)
        .background {
            RoundedRectangle(cornerRadius: AppSpacing.sm)
                .fill(AppColors.surfacePrimary.opacity(0.3))
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: AppSpacing.lg) {
            GoalsProgressCardView(goals: [
                GoalsProgressCardView.Goal(
                    name: "Viaje a Europa",
                    currentAmount: 2500.0,
                    targetAmount: 5000.0
                ),
                GoalsProgressCardView.Goal(
                    name: "Fondo de emergencia",
                    currentAmount: 3200.0,
                    targetAmount: 10000.0
                ),
                GoalsProgressCardView.Goal(
                    name: "Renovación del hogar",
                    currentAmount: 800.0,
                    targetAmount: 3000.0
                )
            ])
        }
        .padding()
    }
    .background(AppBackground())
}

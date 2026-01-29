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
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    // Header
                    headerSection
                        .padding(.horizontal, AppSpacing.md)
                    
                    // Horizontal List
                    goalsScrollSection
                }
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - View Components
    
    private var goalsScrollSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.md) {
                ForEach(goals) { goal in
                    GoalCard(goal: goal)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.md)
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack(spacing: AppSpacing.sm) {
            Text("Mis Metas")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
        }
    }
}

// MARK: - Goal Card Subview
struct GoalCard: View {
    let goal: GoalsProgressCardView.Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            headerView
            
            Spacer()
            
            titleView
            
            progressView
            
            footerView
        }
        .padding(AppSpacing.md)
        .frame(width: 160, height: 130)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfacePrimary.opacity(0.6))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.border.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "target")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }
            
            Spacer()
            
            Text("\(Int(goal.progress * 100))%")
                .font(AppFonts.caption)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
    
    private var titleView: some View {
        Text(goal.name)
            .font(AppFonts.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(AppColors.textPrimary)
            .lineLimit(1)
    }
    
    private var progressView: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColors.surfacePrimary)
                    .frame(height: 4)
                
                Capsule()
                    .fill(AppColors.primary)
                    .frame(width: max(0, geo.size.width * goal.progress), height: 4)
            }
        }
        .frame(height: 4)
    }
    
    private var footerView: some View {
        HStack {
            Text(goal.formattedCurrent)
                .font(.system(size: 10))
                .foregroundStyle(AppColors.textPrimary)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text("/ \(goal.formattedTarget)")
                .font(.system(size: 10))
                .foregroundStyle(AppColors.textSecondary)
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

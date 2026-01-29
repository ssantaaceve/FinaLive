//
//  GoalsProgressCardView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 13/1/2026.
//

import SwiftUI

struct GoalsProgressCardView: View {
    let goals: [Goal]
    @State private var selectedGoalID: UUID?
    @Namespace private var nspace // For arrow animation
    
    struct Goal: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let currentAmount: Double
        let targetAmount: Double
        let icon: String
        let reward: String
        
        var progress: Double {
            min(1.0, max(0.0, currentAmount / targetAmount))
        }
        
        var formattedCurrent: String {
            currentAmount.formatCompact()
        }
        
        var formattedTarget: String {
            targetAmount.formatCompact()
        }
    }
    
    var body: some View {
        // 1. Spacing en 0 para compactar título con contenido
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Objetivos & Premios")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textPrimary)
                .padding(.bottom, 4) // Pequeña separación manual
            
            // Rings Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(goals) { goal in
                        GoalRingView(
                            goal: goal,
                            isSelected: selectedGoalID == goal.id
                        )
                        .matchedGeometryEffect(id: goal.id, in: nspace, isSource: true)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                                if selectedGoalID == goal.id {
                                    selectedGoalID = nil
                                } else {
                                    selectedGoalID = goal.id
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
                // 2. Reducido drásticamente de 8 a 2 para quitar altura vacía
                .padding(.vertical, 4)
            }
            
            // Inline Detail Expansion
            if let selectedID = selectedGoalID, let goal = goals.first(where: { $0.id == selectedID }) {
                InlineGoalDetailView(goal: goal)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95, anchor: .top)),
                            removal: .opacity
                        )
                    )
                    .padding(.top, 8)
            }
        }
        // 3. AQUÍ ESTÁ LA CLAVE DEL TAMAÑO DEL MÓDULO
        // Mantenemos 16 a los lados, pero reducimos a 10 arriba/abajo (antes 16)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            // Unified Golden Glass Box
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.warning.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    AppColors.warning.opacity(0.5),
                                    AppColors.warning.opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        }
        .padding(.horizontal, 16) // Margen externo
    }
}

struct GoalRingView: View {
    let goal: GoalsProgressCardView.Goal
    let isSelected: Bool
    
    // Mantenemos el tamaño original de tu código
    private let size: CGFloat = 40
    private let lineWidth: CGFloat = 4
    
    var body: some View {
        // 4. Reducimos espacio entre bola y texto (de 6 a 2)
        VStack(spacing: 2) {
            ZStack {
                // Background Ring
                Circle()
                    .stroke(AppColors.primary.opacity(0.05), lineWidth: lineWidth)
                    .frame(width: size, height: size)
                
                // Progress Ring
                Circle()
                    .trim(from: 0, to: goal.progress)
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: size, height: size)
                    .shadow(color: AppColors.primary.opacity(0.5), radius: 4)
                
                // Icon
                Image(systemName: goal.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(isSelected ? AppColors.accent : AppColors.textPrimary)
            }
            .scaleEffect(isSelected ? 1.15 : 1.0)
            
            // Small Name Label
            if !isSelected {
                Text("\(Int(goal.progress * 100))%")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

struct InlineGoalDetailView: View {
    let goal: GoalsProgressCardView.Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Header Info
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text("\(goal.formattedCurrent) de \(goal.formattedTarget)")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text("\(Int(goal.progress * 100))%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.primary)
            }
            
            // Linear Progress Detail
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.surfaceElevated)
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geo.size.width * goal.progress), height: 8)
                }
            }
            .frame(height: 8)
            
            // Reward Card
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.warning.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "gift.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.warning)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recompensa")
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                        .textCase(.uppercase)
                    
                    Text(goal.reward)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                }
                
                Spacer()
                
                if goal.progress >= 1.0 {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(AppColors.success)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary.opacity(0.5))
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.surfacePrimary.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.warning.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}



#Preview {
    ZStack {
        AppBackground()
        ScrollView {
            GoalsProgressCardView(goals: [
                GoalsProgressCardView.Goal(
                    name: "Viaje a Europa",
                    currentAmount: 2500000,
                    targetAmount: 5000000,
                    icon: "airplane",
                    reward: "Bono de Viaje $200k"
                ),
                GoalsProgressCardView.Goal(
                    name: "MacBook Pro",
                    currentAmount: 8500000,
                    targetAmount: 9000000,
                    icon: "laptopcomputer",
                    reward: "Case de Cuero"
                ),
                GoalsProgressCardView.Goal(
                    name: "Fondo Emergencia",
                    currentAmount: 1200000,
                    targetAmount: 10000000,
                    icon: "shield.fill",
                    reward: "Tasa Preferencial"
                )
            ])
            .padding(.vertical)
        }
    }
}

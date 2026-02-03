//
//  BalanceCardView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Card de balance con toggle de visibilidad y variación porcentual
/// Estilo premium glass/liquid glass con gradiente decorativo
struct BalanceCardView: View {
    let balance: Decimal
    let formattedBalance: String
    let percentageChange: String
    let income: Decimal
    let formattedIncome: String
    let expense: Decimal
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
            // Gradiente decorativo sutil (Mantenido igual)
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
            
            VStack(alignment: .leading, spacing: 20) {
                
                // BLOQUE 1: Header, Selector y Balance (Todo junto y compacto)
                VStack(alignment: .leading, spacing: 6) {
                    // Fila 1: Título y Ojo
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
                    
                    // Fila 2: Selector de Periodo (Pegado al título)
                    periodSelector
                        .padding(.top, 2)
                    
                    // Fila 3: Balance Grande (Pegado al selector)
                    Text(showBalance ? formattedBalance : "••••••••")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.textPrimary)
                        .contentTransition(.opacity)
                        .padding(.top, 4) // Ligera separación visual para el número
                    
                    // Fila 4: Porcentaje (Pequeño y alineado)
                    if showBalance {
                        Text(percentageChange)
                            .font(.caption) // Más pequeño como pediste
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.success)
                    }
                }
                .padding(.horizontal, 4)
                
                // BLOQUE 2: Cápsulas de Ingresos y Gastos (SIN ICONOS)
                incomeExpenseCapsules
                
                // BLOQUE 3: Burbujas de Categorías
                if showBalance {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            categoryBubble(icon: "cart.fill", name: "Super", amount: expense * Decimal(0.4), color: .orange)
                            categoryBubble(icon: "car.fill", name: "Auto", amount: expense * Decimal(0.2), color: .blue)
                            categoryBubble(icon: "popcorn.fill", name: "Ocio", amount: expense * Decimal(0.15), color: .purple)
                            categoryBubble(icon: "cross.case.fill", name: "Salud", amount: expense * Decimal(0.1), color: .red)
                            categoryBubble(icon: "book.fill", name: "Edu", amount: expense * Decimal(0.15), color: .green)
                        }
                        .padding(.horizontal, 4)
                        .padding(.bottom, 2)
                    }
                }
            }
            .padding(20)
        }
        // Background "Liquid Contour"
        .padding(.horizontal, 16)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppColors.surfacePrimary.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        AppColors.textPrimary.opacity(0.2),
                                        AppColors.textPrimary.opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Componentes
    
    private var periodSelector: some View {
        HStack(spacing: 0) { // Spacing 0 para controlar con padding interno
            ForEach(Period.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(
                            selectedPeriod == period
                                ? AppColors.textPrimary
                                : AppColors.textSecondary
                        )
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background {
                            if selectedPeriod == period {
                                Capsule()
                                    .fill(AppColors.surfaceElevated)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // Nuevas Cápsulas Estilo App (Limpias, sin iconos)
    private var incomeExpenseCapsules: some View {
        HStack(spacing: 12) {
            // Cápsula Ingresos (Verde Sutil)
            statCapsule(
                title: "Ingresos",
                amount: formattedIncome,
                color: AppColors.success
            )
            
            // Cápsula Gastos (Roja Sutil)
            statCapsule(
                title: "Gastos",
                amount: formattedExpense,
                color: Color.red // Forzamos rojo si AppColors.error varía
            )
        }
    }
    
    private func statCapsule(title: String, amount: String, color: Color) -> some View {
        // Al quitar el icono, usamos VStack para apilar título y monto
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
                .textCase(.uppercase)
            
            Text(showBalance ? amount : "••••")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading) // Asegura que ocupe el ancho disponible y alinee a la izq
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.05)) // Fondo muy sutil del color correspondiente
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(0.15), lineWidth: 1) // Borde sutil del color
                )
        }
    }
    
    private func categoryBubble(icon: String, name: String, amount: Decimal, color: Color) -> some View {
        Button(action: {}) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(color)
                }
                
                Text(amount.formatCompact())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        AppBackground()
        BalanceCardView(
            balance: Decimal(15420.50),
            formattedBalance: "$15,420.50",
            percentageChange: "+2.5% vs mes anterior",
            income: Decimal(2500.00),
            formattedIncome: "$2,500.00",
            expense: Decimal(1249.50),
            formattedExpense: "$1,249.50"
        )
        .padding()
    }
}

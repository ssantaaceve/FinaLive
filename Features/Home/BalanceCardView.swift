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
    
    // Novedades Fase 3: Datos de Ciclo
    let cycleDateRange: String      // Ej: "15 Ene - 14 Feb"
    let cycleStartDay: Int          // Para lógica de nudge (punto rojo)
    
    // Novedades Fase Data Viz: Distribución
    let categoryDistributions: [CategoryDistributionItem]
    
    @State private var selectedPeriod: Period = .cycle
    @State private var showCycleInfoAlert: Bool = false // Nueva alerta educativa
    
    enum Period: String, CaseIterable {
        case cycle = "Este Ciclo"
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
                
                // BLOQUE 1: Header, Selector y Balance
                VStack(alignment: .leading, spacing: 6) {
                    
                    // Fila 1: Título (Rango de Fechas) y Botones (Config)
                    HStack {
                        // Header Dinámico: Rango de Fechas
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tu Dinero")
                                .font(AppFonts.caption)
                                .foregroundStyle(AppColors.textSecondary)
                            
                            Text(cycleDateRange)
                                .font(AppFonts.headline)
                                .foregroundStyle(AppColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            // Botón de Configuración con Nudge
                            Button(action: {
                                showCycleInfoAlert = true
                            }) {
                                ZStack(alignment: .topTrailing) {
                                    Image(systemName: "info.circle.fill") // Cambio de icono a Info
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(AppColors.textSecondary.opacity(0.8))
                                        .frame(width: 32, height: 32)
                                    
                                    // Nudge: Sugerir cambio si usa el día por defecto (1)
                                    if cycleStartDay == 1 {
                                        Circle()
                                            .fill(AppColors.warning)
                                            .frame(width: 8, height: 8)
                                            .offset(x: 2, y: 2)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .alert("Personaliza tu Balance", isPresented: $showCycleInfoAlert) {
                                Button("Entendido", role: .cancel) { }
                            } message: {
                                Text("Recuerda que puedes ajustar tu ciclo financiero a tu medida. Dirígete a tu Configuración de Usuario en el Perfil para modificar tu día de corte.")
                            }
                        }
                    }
                    
                    // Fila 2: Selector de Periodo (Pegado al título)
                    periodSelector
                        .padding(.top, 4)
                    
                    // Fila 3: Balance Grande (Pegado al selector)
                    Text(formattedBalance)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(.top, 4)
                    
                    // Fila 4: Porcentaje (Pequeño y alineado)
                    Text(percentageChange)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.success)
                }
                .padding(.horizontal, 4)
                
                // BLOQUE 2: Cápsulas de Ingresos y Gastos
                incomeExpenseCapsules
                
                // BLOQUE 3: Burbujas de Categorías (Dinámico)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        if categoryDistributions.isEmpty {
                            // Placeholder si no hay gastos
                            Text("No hay gastos registrados en este ciclo")
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)
                                .padding(.leading, 4)
                        } else {
                            ForEach(categoryDistributions) { item in
                                categoryBubble(
                                    icon: item.icon,
                                    name: item.name, // Podríamos truncar si es muy largo
                                    amount: item.amount,
                                    color: item.color
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 2)
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
        HStack(spacing: 0) {
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
    
    // Nuevas Cápsulas Estilo App
    private var incomeExpenseCapsules: some View {
        HStack(spacing: 12) {
            // Cápsula Ingresos
            statCapsule(
                title: "Ingresos",
                amount: formattedIncome,
                color: AppColors.success
            )
            
            // Cápsula Gastos
            statCapsule(
                title: "Gastos",
                amount: formattedExpense,
                color: Color.red
            )
        }
    }
    
    private func statCapsule(title: String, amount: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
                .textCase(.uppercase)
            
            Text(amount)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(0.15), lineWidth: 1)
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
            percentageChange: "+2.5% vs ciclo anterior",
            income: Decimal(2500.00),
            formattedIncome: "$2,500.00",
            expense: Decimal(1249.50),
            formattedExpense: "$1,249.50",
            cycleDateRange: "15 Ene - 14 Feb",
            cycleStartDay: 1, // Prueba con 1 para ver el punto rojo (warning)
            categoryDistributions: [] // Preview Empty
        )
        .padding()
    }
}

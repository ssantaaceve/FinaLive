//
//  CycleConfigView.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import SwiftUI

struct CycleConfigView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    
    // Grid para los círculos de días
    let columns = [
        GridItem(.adaptive(minimum: 44, maximum: 50))
    ]
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                // Header (Título e Instrucción Humanizada)
                VStack(spacing: 8) {
                    Text("Tu Mes Financiero")
                        .font(AppFonts.title2)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text("¿Qué día sueles recibir tu ingreso principal o nómina?")
                        .font(AppFonts.body)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    Text("Ajustaremos tus reportes para que vayan de pago a pago. Así no verás números rojos injustos si tu mes empieza el día 15 o el 25.")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 4)
                }
                .padding(.top, 24)
                .padding(.bottom, 32)
                
                // Selector de Día
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1...31, id: \.self) { day in
                            DayCircleButton(
                                day: day,
                                isSelected: viewModel.cycleStartDay == day,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        viewModel.updateCycleDay(day)
                                    }
                                }
                            )
                        }
                    }
                    .padding(24)
                }
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(AppColors.surfacePrimary.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(AppColors.border.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 16)
                
                // Resumen Visual con Feedback Dinámico
                VStack(spacing: 4) {
                    Text(feedbackText)
                        .font(AppFonts.body)
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar) // Ocultar TabBar nativo (si existe)
        .onAppear {
            withAnimation {
                router.isTabBarHidden = true
            }
        }
        .onDisappear {
            withAnimation {
                router.isTabBarHidden = false
            }
        }
    }
    
    // Lógica simple para el texto de feedback
    var feedbackText: String {
        let start = viewModel.cycleStartDay
        // Si empieza el 1, termina a fin de mes (o día 30/31 hipotético anterior)
        // Para simplificar UX: si empieza el 15, termina el 14.
        let end = start == 1 ? "fin de mes" : "\(start - 1)"
        
        // Formateo con negritas usando Markdown de SwiftUI
        return "Tu mes irá del día **\(start)** al **\(end)** del siguiente mes."
    }
}

// Componente visual para cada botón de día
struct DayCircleButton: View {
    let day: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Indicador de selección (Brillo/Sombra)
                if isSelected {
                    Circle()
                        .fill(AppColors.primary.opacity(0.2))
                        .frame(width: 54, height: 54)
                        .blur(radius: 4)
                }
                
                Circle()
                    .fill(
                        isSelected
                        ? AppColors.primary
                        : AppColors.surfaceElevated.opacity(0.5)
                    )
                    .frame(width: 44, height: 44)
                    .shadow(
                        color: isSelected ? AppColors.primary.opacity(0.5) : .clear,
                        radius: 4, x: 0, y: 2
                    )
                
                Text("\(day)")
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .black : AppColors.textPrimary)
                
                // Pequeño indicador (flecha/punto) si está seleccionado
                if isSelected {
                    Circle()
                        .fill(.white)
                        .frame(width: 4, height: 4)
                        .offset(y: 16)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CycleConfigView(
        viewModel: ProfileViewModel(),
        router: AppRouter()
    )
}

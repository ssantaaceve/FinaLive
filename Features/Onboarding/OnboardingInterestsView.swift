//
//  OnboardingInterestsView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 13/1/2026.
//

import SwiftUI

struct OnboardingInterestsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isOthersExpanded: Bool = false
    
    let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Grid de intereses + Card "Otros"
            ZStack {
                // Glow Effect (Detrás del Grid)
                Circle()
                    .fill(AppColors.warning.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                
                VStack(spacing: AppSpacing.md) {
                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        // Filtramos .other para mostrarlo aparte
                        ForEach(OnboardingViewModel.OnboardingInterest.allCases.filter { $0 != .other }) { interest in
                            InterestCard(
                                interest: interest,
                                isSelected: viewModel.selectedInterests.contains(interest)
                            ) {
                                viewModel.toggleInterest(interest)
                            }
                        }
                    }
                    
                    // Card "Otros" Independiente y Expandible
                    OthersCard(
                        isExpanded: $isOthersExpanded,
                        text: $viewModel.othersText,
                        isSelected: viewModel.selectedInterests.contains(.other)
                    ) {
                        // Al tocar en estado colapsado (Abrir)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isOthersExpanded = true
                            if !viewModel.selectedInterests.contains(.other) {
                                viewModel.toggleInterest(.other)
                            }
                        }
                    } onCancel: {
                        // Al cancelar (Cerrar y Limpiar)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isOthersExpanded = false
                            viewModel.othersText = ""
                            if viewModel.selectedInterests.contains(.other) {
                                viewModel.toggleInterest(.other) // Deseleccionar
                            }
                        }
                    }

                }
                .padding(.horizontal, AppSpacing.xl)
            }
            
            Spacer()
            
            // Content (Texto Abajo - Pegado al Grid)
            VStack(spacing: AppSpacing.md) {
                Text("Beneficios solo para ti")
                    .font(AppFonts.title.bold())
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Elige las áreas que más te interesan y personalizaremos tus beneficios exclusivos.")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
                    .fixedSize(horizontal: false, vertical: true) // Evita que se corte
            }
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
    }
}

// MARK: - Components

private struct OthersCard: View {
    @Binding var isExpanded: Bool
    @Binding var text: String
    let isSelected: Bool
    let onTap: () -> Void
    let onCancel: () -> Void
    
    // Focus state para abrir el teclado automáticamente
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            if isExpanded {
                // Estado Expandido: Input Activo
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .foregroundStyle(AppColors.primary)
                    
                    TextField("", text: $text, prompt: Text("Escribe tu interés...").foregroundColor(AppColors.textSecondary.opacity(0.5)))
                        .font(AppFonts.body)
                        .foregroundStyle(AppColors.textPrimary)
                        .tint(AppColors.primary)
                        .focused($isFocused)
                        .submitLabel(.done)
                    
                    // Botón "Cancelar/Eliminar" (X)
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.textSecondary.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.lg)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(AppColors.primary, lineWidth: 2)
                        .background(.clear)
                }
                .onAppear {
                    // Dar foco automáticamente al expandir
                    isFocused = true
                }
                
            } else {
                // Estado Colapsado: Grid Card Normal
                HStack {
                   Spacer()
                   InterestCard(
                        interest: .other,
                        isSelected: isSelected,
                        action: onTap
                   )
                   .frame(width: (UIScreen.main.bounds.width - (AppSpacing.xl * 2) - AppSpacing.md) / 2) // Simula ancho de columna
                   Spacer()
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isExpanded)
    }
}

private struct InterestCard: View {
    let interest: OnboardingViewModel.OnboardingInterest
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: interest.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.textSecondary)
                
                Text(interest.rawValue)
                    .font(AppFonts.headline)
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isSelected ? AppColors.primary : AppColors.border.opacity(0.5),
                        lineWidth: isSelected ? 2 : 1
                    )
                    .background(.clear)
            }
            .shadow(
                color: isSelected ? AppColors.primary.opacity(0.2) : Color.clear,
                radius: 12,
                x: 0,
                y: 0
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        OnboardingInterestsView(viewModel: OnboardingViewModel())
    }
}

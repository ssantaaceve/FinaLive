//
//  HomeBottomNavigationView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Navegación inferior premium con tabs y botón central flotante con gestos
struct HomeBottomNavigationView: View {
    @Binding var selectedTab: BottomTab
    let onTransactionAction: (TransactionAction) -> Void
    
    @Binding var isDragging: Bool
    @Binding var dragDirection: DragDirection
    @Binding var dragProgress: CGFloat // 0.0 a 1.0
    
    @State private var dragOffset: CGFloat = 0
    
    enum BottomTab: String, CaseIterable {
        case home = "Inicio"
        case profile = "Perfil"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .profile: return "person.fill"
            }
        }
    }
    
    enum DragDirection {
        case none
        case up    // Gasto
        case down  // Ingreso
    }
    
    private let dragThreshold: CGFloat = 30
    private let maxDragDistance: CGFloat = 60
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Tab Home (izquierda)
            tabButton(for: .home)
            
            // Botón central flotante con gestos
            centralFloatingButton
                .frame(width: 64, height: 64)
            
            // Tab Profile (derecha)
            tabButton(for: .profile)
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.vertical, AppSpacing.md + AppSpacing.xs)
        .background {
            // Pill ovalado flotante con efecto glass
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .background(
                    Capsule()
                        .fill(Color.clear)
                )
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
                .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: 16)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.md)
    }
    
    // MARK: - View Components
    
    private func tabButton(for tab: BottomTab) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        }) {
            Image(systemName: tab.icon)
                .font(.system(size: 24, weight: selectedTab == tab ? .semibold : .medium))
                .foregroundStyle(AppColors.textPrimary)
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
    
    private var centralFloatingButton: some View {
        ZStack {
            // Círculo de fondo con gradiente
            Circle()
                .fill(AppColors.primary.gradient)
                .frame(width: 64, height: 64)
                .shadow(color: AppColors.primary.opacity(0.5), radius: 16, x: 0, y: 6)
                .shadow(color: .black.opacity(0.3), radius: 24, x: 0, y: 12)
            
            // Ícono +
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
        }
        .scaleEffect(isDragging ? 1.15 : 1.0)
        .offset(y: dragOffset)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isDragging {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isDragging = true
                        }
                    }
                    
                    // Detectar dirección principal
                    let verticalMovement = value.translation.height
                    
                    // Limitar distancia de arrastre (seguir directamente el gesto)
                    dragOffset = max(-maxDragDistance, min(maxDragDistance, verticalMovement))
                    
                    // Actualizar progreso
                    let progress = min(1.0, abs(dragOffset) / maxDragDistance)
                    dragProgress = progress
                    
                    // Determinar dirección
                    if abs(verticalMovement) > 10 {
                        let newDirection = verticalMovement < 0 ? DragDirection.up : DragDirection.down
                        if dragDirection != newDirection {
                            withAnimation(.easeOut(duration: 0.15)) {
                                dragDirection = newDirection
                            }
                        }
                    } else {
                        dragDirection = .none
                    }
                }
                .onEnded { value in
                    let verticalMovement = value.translation.height
                    
                    // Disparar acción si supera el threshold
                    if abs(verticalMovement) > dragThreshold {
                        if verticalMovement < 0 {
                            // Drag arriba → Gasto
                            onTransactionAction(.expense)
                        } else {
                            // Drag abajo → Ingreso
                            onTransactionAction(.income)
                        }
                    }
                    
                    // Reset animado
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dragOffset = 0
                        dragDirection = .none
                        dragProgress = 0
                    }
                    
                    // Reset estado después de la animación
                    Task {
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        isDragging = false
                    }
                }
        )
    }
}

#Preview {
    ZStack {
        AppBackground()
        
        VStack {
            Spacer()
            
            HomeBottomNavigationView(
                selectedTab: .constant(.home),
                onTransactionAction: { action in
                    print("Action: \(action)")
                },
                isDragging: .constant(false),
                dragDirection: .constant(.none),
                dragProgress: .constant(0)
            )
        }
    }
}

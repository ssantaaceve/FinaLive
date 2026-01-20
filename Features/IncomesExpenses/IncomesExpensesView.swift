//
//  IncomesExpensesView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista principal de Ingresos y Gastos
/// Muestra lista de movimientos con efecto glass y botón flotante con gestos
struct IncomesExpensesView: View {
    @StateObject private var viewModel = IncomesExpensesViewModel()
    @State private var navigationPath = NavigationPath()
    
    // Estados para el gesto del botón
    @State private var isDragging: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var dragDirection: DragDirection = .none
    
    enum DragDirection {
        case none
        case up    // Gasto
        case down  // Ingreso
    }
    
    private let dragThreshold: CGFloat = 30
    private let maxDragDistance: CGFloat = 60
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Fondo gradiente
                AppBackground()
                
                VStack(spacing: 0) {
                    // Header personalizado
                    headerView
                    
                    // Lista de transacciones
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(AppSpacing.xl)
                    } else if viewModel.transactions.isEmpty {
                        emptyStateView
                    } else {
                        transactionsList
                    }
                }
                
                // Botón flotante con gestos
                floatingAddButton
                
                // Overlay de feedback durante el gesto
                if isDragging && dragDirection != .none {
                    dragFeedbackOverlay
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .addExpense:
                    AddExpenseView()
                case .addIncome:
                    AddIncomeView()
                }
            }
            .refreshable {
                await viewModel.refreshAsync()
            }
        }
    }
    
    // MARK: - Navigation
    
    enum NavigationDestination: Hashable {
        case addExpense
        case addIncome
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        HStack {
            Text("Ingresos y Gastos")
                .font(AppFonts.title2)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md)
    }
    
    private var transactionsList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRowView(transaction: transaction) {
                        // TODO: Navegar a detalle de transacción
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, 100) // Espacio para el botón flotante
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text("No hay movimientos aún")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textSecondary)
            
            Text("Toca el botón + para agregar tu primer movimiento")
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
    }
    
    private var floatingAddButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.primary.gradient)
                        .frame(width: 64, height: 64)
                        .shadow(color: AppColors.primary.opacity(0.5), radius: 16, x: 0, y: 6)
                        .shadow(color: .black.opacity(0.3), radius: 24, x: 0, y: 12)
                    
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
                            
                            // Limitar distancia de arrastre
                            dragOffset = max(-maxDragDistance, min(maxDragDistance, -verticalMovement))
                            
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
                            
                            // Navegar si supera el threshold
                            if abs(verticalMovement) > dragThreshold {
                                if verticalMovement < 0 {
                                    // Swipe up → Gasto
                                    navigationPath.append(NavigationDestination.addExpense)
                                } else {
                                    // Swipe down → Ingreso
                                    navigationPath.append(NavigationDestination.addIncome)
                                }
                            }
                            
                            // Reset animado
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                dragOffset = 0
                                dragDirection = .none
                            }
                            
                            // Reset estado después de la animación
                            Task {
                                try? await Task.sleep(nanoseconds: 300_000_000)
                                isDragging = false
                            }
                        }
                )
                
                Spacer()
            }
            .padding(.bottom, AppSpacing.lg)
        }
    }
    
    private var dragFeedbackOverlay: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let buttonY = screenHeight - (AppSpacing.lg + 32) // Posición del botón
            let buttonCenter = UnitPoint(x: 0.5, y: buttonY / screenHeight)
            
            // Color del overlay basado en la dirección
            let overlayColor = dragDirection == .up ? AppColors.error : AppColors.success
            
            // Radio dinámico
            let maxRadius = max(screenWidth, screenHeight) * 1.5
            let progress = min(1.0, abs(dragOffset) / maxDragDistance)
            let currentRadius = 40 + (maxRadius - 40) * progress
            
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: overlayColor.opacity(0.4 * progress), location: 0),
                    .init(color: overlayColor.opacity(0.2 * progress), location: 0.3),
                    .init(color: overlayColor.opacity(0.05 * progress), location: 0.6),
                    .init(color: overlayColor.opacity(0), location: 1)
                ]),
                center: buttonCenter,
                startRadius: 0,
                endRadius: currentRadius
            )
            .blendMode(.screen)
        }
    }
}

#Preview {
    IncomesExpensesView()
}

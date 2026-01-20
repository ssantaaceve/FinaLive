//
//  HomeView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Vista principal de la aplicación
/// Muestra el resumen financiero y permite navegar a otras secciones
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var router: AppRouter
    @State private var showAddTransaction = false
    @State private var selectedBottomTab: HomeBottomNavigationView.BottomTab = .home
    @State private var transactionActionType: TransactionAction?
    @State private var isDraggingTransaction: Bool = false
    @State private var dragDirection: HomeBottomNavigationView.DragDirection = .none
    @State private var dragProgress: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo principal
                AppBackground()
                
                VStack(spacing: 0) {
                    // Header personalizado
                    HomeHeaderView(
                        userName: viewModel.userName,
                        hasNotifications: viewModel.hasNotifications,
                        onNotificationsTap: {
                            // TODO: Navegar a notificaciones
                        }
                    )
                    
                    // Contenido scrolleable
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.lg) {
                            balanceCard
                            
                            goalsProgressCard
                            
                            recentTransactionsView
                            
                            transactionsSection
                        }
                        .padding(AppSpacing.md)
                        .padding(.bottom, AppSpacing.xl)
                    }
                }
                
                // Navegación inferior flotante (fuera del VStack principal)
                VStack {
                    Spacer()
                    
                    HomeBottomNavigationView(
                        selectedTab: $selectedBottomTab,
                        onTransactionAction: { action in
                            transactionActionType = action
                            showAddTransaction = true
                        },
                        isDragging: $isDraggingTransaction,
                        dragDirection: $dragDirection,
                        dragProgress: $dragProgress
                    )
                }
                
                // Overlay de efecto radial durante el gesto
                if isDraggingTransaction && dragDirection != .none {
                    dragOverlayEffect
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView(router: router)
            }
            .onChange(of: transactionActionType) { oldValue, newValue in
                if let action = newValue {
                    print("Transaction Action: \(action)")
                    // TODO: Pasar el tipo de transacción a AddTransactionView
                    transactionActionType = nil
                }
            }
            .refreshable {
                await viewModel.refreshAsync()
            }
        }
    }
    
    // MARK: - View Components
    
    private var dragOverlayEffect: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let buttonY = screenHeight - 50 // Posición aproximada del botón central (bottom nav)
            let buttonCenter = UnitPoint(x: 0.5, y: buttonY / screenHeight)
            
            // Radio dinámico basado en el progreso del gesto (más expansivo)
            let maxRadius = max(screenWidth, screenHeight) * 1.5
            let currentRadius = 50 + (maxRadius - 50) * dragProgress
            
            ZStack {
                // Gradiente radial tipo "luz bombillo" más intenso y expansivo
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: overlayColor.opacity(0.7 * dragProgress), location: 0),
                        .init(color: overlayColor.opacity(0.4 * dragProgress), location: 0.15),
                        .init(color: overlayColor.opacity(0.2 * dragProgress), location: 0.3),
                        .init(color: overlayColor.opacity(0.08 * dragProgress), location: 0.5),
                        .init(color: overlayColor.opacity(0.03 * dragProgress), location: 0.75),
                        .init(color: overlayColor.opacity(0), location: 1)
                    ]),
                    center: buttonCenter,
                    startRadius: 40,
                    endRadius: currentRadius
                )
                .blendMode(.screen)
                
                // Segundo gradiente más sutil para suavizar el efecto
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: overlayColor.opacity(0.3 * dragProgress), location: 0),
                        .init(color: overlayColor.opacity(0.1 * dragProgress), location: 0.4),
                        .init(color: overlayColor.opacity(0), location: 1)
                    ]),
                    center: buttonCenter,
                    startRadius: 0,
                    endRadius: currentRadius * 0.8
                )
                .blendMode(.overlay)
            }
        }
    }
    
    private var overlayColor: Color {
        switch dragDirection {
        case .up:
            return AppColors.error
        case .down:
            return AppColors.success
        case .none:
            return .clear
        }
    }
    
    private var balanceCard: some View {
        BalanceCardView(
            balance: viewModel.balance,
            formattedBalance: viewModel.formattedBalance,
            percentageChange: viewModel.percentageChange,
            income: viewModel.income,
            formattedIncome: viewModel.formattedIncome,
            expense: viewModel.expense,
            formattedExpense: viewModel.formattedExpense
        )
    }
    
    private var goalsProgressCard: some View {
        GoalsProgressCardView(goals: viewModel.goals)
    }
    
    private var recentTransactionsView: some View {
        RecentTransactionsView(
            transactions: viewModel.recentTransactions,
            onSeeAllTap: {
                // TODO: Navegar a lista completa de transacciones
                print("Ver todos los movimientos")
            },
            onTransactionTap: { transaction in
                // TODO: Navegar a detalle de transacción
                print("Transaction tapped: \(transaction.description)")
            }
        )
    }
    
    private var transactionsSection: some View {
        VStack(spacing: AppSpacing.md) {
            if viewModel.isLoading {
                ProgressView()
                    .padding(AppSpacing.md)
            } else {
                emptyStateView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.sm + AppSpacing.xs) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text("No hay transacciones aún")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textSecondary)
            
            Text("Toca el botón + para agregar tu primera transacción")
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, AppSpacing.lg + AppSpacing.md)
    }
}

#Preview {
    HomeView(router: AppRouter())
}

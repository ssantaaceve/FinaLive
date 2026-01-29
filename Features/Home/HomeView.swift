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
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Fondo principal
                AppBackground()
                
                VStack(spacing: 0) {
                    // Header personalizado
                    HomeHeaderView(
                        userName: viewModel.userName,
                        hasNotifications: viewModel.hasNotifications,
                        onNotificationsTap: {
                            navigationPath.append(NavigationDestination.notifications)
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
                        .padding(.bottom, 100) // Espacio para la bottom bar persistente
                    }
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .notifications:
                    NotificationsView(router: router)
                }
            }
            .refreshable {
                await viewModel.refreshAsync()
            }
        }
    }
    
    // MARK: - Navigation
    
    enum NavigationDestination: Hashable {
        case notifications
    }
    
    // MARK: - View Components
    
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
        .padding(.horizontal, AppSpacing.md)
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
        .padding(.horizontal, AppSpacing.md)
    }
    
    private var transactionsSection: some View {
        VStack(spacing: AppSpacing.md) {
            if viewModel.isLoading {
                ProgressView()
                    .padding(AppSpacing.md)
            } else if viewModel.recentTransactions.isEmpty {
                emptyStateView
            }
        }
        .padding(.horizontal, AppSpacing.md)
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

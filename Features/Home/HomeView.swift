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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header personalizado
                HomeHeaderView(
                    userName: viewModel.userName,
                    hasNotifications: viewModel.hasNotifications,
                    onNotificationsTap: {
                        // TODO: Navegar a notificaciones
                    }
                )
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        balanceCard
                        
                        transactionsSection
                    }
                    .padding(AppSpacing.md)
                }
            }
            .background(AppBackground())
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTransaction = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(AppFonts.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView(router: router)
            }
            .refreshable {
                await viewModel.refreshAsync()
            }
        }
    }
    
    // MARK: - View Components
    
    private var balanceCard: some View {
        CardView {
            VStack(spacing: AppSpacing.md) {
                // Balance Total
                VStack(spacing: AppSpacing.sm + AppSpacing.xs) {
                    Text("Balance Total")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textSecondary)
                    
                    Text(viewModel.formattedBalance)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.textPrimary)
                }
                .frame(maxWidth: .infinity)
                
                // Separador sutil
                Rectangle()
                    .fill(AppColors.border.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.vertical, AppSpacing.xs)
                
                // Ingresos y Gastos
                incomeExpenseSection
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var incomeExpenseSection: some View {
        HStack(spacing: AppSpacing.md) {
            incomeModule
            expenseModule
        }
    }
    
    private var incomeModule: some View {
        VStack(spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.success)
                
                Text("Ingresos")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Text(viewModel.formattedIncome)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var expenseModule: some View {
        VStack(spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.error)
                
                Text("Gastos")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Text(viewModel.formattedExpense)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
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

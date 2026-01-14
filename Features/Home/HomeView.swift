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
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    balanceCard
                    
                    transactionsSection
                }
                .padding(AppSpacing.md)
            }
            .navigationTitle("FinaLive")
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
            VStack(spacing: AppSpacing.sm + AppSpacing.xs) {
                Text("Balance Total")
                    .font(AppFonts.headline)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.formattedBalance)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
        }
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
                .foregroundStyle(.tertiary)
            
            Text("No hay transacciones aún")
                .font(AppFonts.headline)
                .foregroundStyle(.secondary)
            
            Text("Toca el botón + para agregar tu primera transacción")
                .font(AppFonts.body)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, AppSpacing.lg + AppSpacing.md)
    }
}

#Preview {
    HomeView(router: AppRouter())
}

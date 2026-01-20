//
//  RecentTransactionsView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Módulo de últimos movimientos (transacciones recientes)
/// Card glass con lista de transacciones y header con acción
struct RecentTransactionsView: View {
    let transactions: [Transaction]
    let onSeeAllTap: (() -> Void)?
    let onTransactionTap: ((Transaction) -> Void)?
    
    init(
        transactions: [Transaction],
        onSeeAllTap: (() -> Void)? = nil,
        onTransactionTap: ((Transaction) -> Void)? = nil
    ) {
        self.transactions = transactions
        self.onSeeAllTap = onSeeAllTap
        self.onTransactionTap = onTransactionTap
    }
    
    var body: some View {
        Group {
            if !transactions.isEmpty {
                VStack(spacing: AppSpacing.md) {
                    // Header
                    headerSection
                    
                    // Lista de transacciones
                    transactionsList
                }
                .padding(AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.lg)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.lg)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            AppColors.border.opacity(0.2),
                                            AppColors.border.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        }
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
                }
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack(spacing: AppSpacing.md) {
            Text("Últimos movimientos")
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                onSeeAllTap?()
            }) {
                Text("Ver todos")
                    .font(AppFonts.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.primary)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var transactionsList: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(transactions) { transaction in
                TransactionRowView(transaction: transaction) {
                    onTransactionTap?(transaction)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: AppSpacing.lg) {
            RecentTransactionsView(
                transactions: [
                    Transaction(
                        type: .expense,
                        category: "Compras",
                        description: "Supermercado",
                        amount: 125.50,
                        date: Date()
                    ),
                    Transaction(
                        type: .expense,
                        category: "Alimentación",
                        description: "Café y desayuno",
                        amount: 15.00,
                        date: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date()
                    ),
                    Transaction(
                        type: .income,
                        category: "Salario",
                        description: "Pago quincenal",
                        amount: 2500.00,
                        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                    ),
                    Transaction(
                        type: .expense,
                        category: "Servicios",
                        description: "Arriendo",
                        amount: 800.00,
                        date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
                    )
                ],
                onSeeAllTap: {
                    print("Ver todos")
                },
                onTransactionTap: { transaction in
                    print("Transaction tapped: \(transaction.description)")
                }
            )
        }
        .padding()
    }
    .background(AppBackground())
}

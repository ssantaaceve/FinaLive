//
//  RecentTransactionsView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 13/1/2026.
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
                VStack(spacing: 0) {
                    // Header
                    headerSection
                        .padding(20)
                    
                    Divider()
                        .background(AppColors.border.opacity(0.3))
                    
                    // Lista de transacciones
                    VStack(spacing: 0) {
                        ForEach(Array(transactions.prefix(5).enumerated()), id: \.element.id) { index, transaction in
                            if index > 0 {
                                Divider()
                                    .background(AppColors.border.opacity(0.2))
                                    .padding(.leading, 20)
                            }
                            
                            TransactionRowView(transaction: transaction) {
                                onTransactionTap?(transaction)
                            }
                        }
                    }
                }
                // AQUÍ ESTÁ EL CAMBIO APLICADO:
                .background {
                    ZStack {
                        // Pure Liquid Contour (No Ugly Gray)
                        RoundedRectangle(cornerRadius: 24)
                            .fill(AppColors.surfacePrimary.opacity(0.05)) // Almost invisible fill
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                AppColors.textPrimary.opacity(0.2), // Light Top
                                                AppColors.textPrimary.opacity(0.05) // Faded Bottom
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    }
                }
                .padding(.horizontal, 16) // External Margin
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

// MARK: - Preview Helpers
// (Asegúrate de tener estas extensiones o cambiar los colores si te da error en AppColors)

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

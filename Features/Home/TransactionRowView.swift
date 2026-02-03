//
//  TransactionRowView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Componente reutilizable para mostrar una fila de transacción
/// Diseño simplificado: descripción, fecha y monto con estilo glass sutil
struct TransactionRowView: View {
    let transaction: Transaction
    let onTap: (() -> Void)?
    
    @State private var isPressed = false
    
    init(transaction: Transaction, onTap: (() -> Void)? = nil) {
        self.transaction = transaction
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(alignment: .center, spacing: AppSpacing.md) {
                // Información de la transacción
                transactionInfo
                
                // Monto (punto focal visual)
                amountView
            }
            .padding(.vertical, 12) // Vertical padding for row
            .padding(.horizontal, 20) // Horizontal padding to align with container
            .contentShape(Rectangle()) // Ensure tappable area
            .background(
                AppColors.surfacePrimary.opacity(isPressed ? 0.05 : 0.0) // Subtle press state
            )
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
    
    // MARK: - View Components
    
    private var transactionInfo: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Descripción principal
            Text(transaction.description ?? transaction.category)
                .font(AppFonts.headline)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
            
            // Fecha y categoría (secundaria)
            HStack(spacing: AppSpacing.xs) {
                Text(transaction.formattedDate)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("•")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textPrimary.opacity(0.5))
                
                Text(transaction.category)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var amountView: some View {
        Text(transaction.formattedAmount)
            .font(AppFonts.headline)
            .fontWeight(.semibold)
            .foregroundStyle(transaction.type == .income ? AppColors.success : AppColors.error)
            .multilineTextAlignment(.trailing)
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        TransactionRowView(
            transaction: Transaction(
                type: .expense,
                category: "Compras",
                description: "Supermercado",
                amount: Decimal(125.50),
                date: Date()
            )
        )
        
        TransactionRowView(
            transaction: Transaction(
                type: .income,
                category: "Salario",
                description: "Pago quincenal",
                amount: Decimal(2500.00),
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            )
        )
    }
    .padding()
    .background(AppBackground())
}

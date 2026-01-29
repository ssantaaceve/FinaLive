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
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.md)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surfacePrimary.opacity(0.6))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.border.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: isPressed)
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
            Text(transaction.description)
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
                amount: 125.50,
                date: Date()
            )
        )
        
        TransactionRowView(
            transaction: Transaction(
                type: .income,
                category: "Salario",
                description: "Pago quincenal",
                amount: 2500.00,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            )
        )
    }
    .padding()
    .background(AppBackground())
}

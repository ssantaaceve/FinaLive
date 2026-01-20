//
//  TransactionRowView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Componente reutilizable para mostrar una fila de transacción
/// Estilo glass premium con ícono, descripción, monto y chevron
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
            HStack(spacing: AppSpacing.sm) {
                // Ícono circular
                iconView
                
                // Información de la transacción
                transactionInfo
                
                // Monto
                amountView
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColors.border)
            }
            .padding(AppSpacing.sm)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.md)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.md)
                            .strokeBorder(AppColors.border.opacity(0.1), lineWidth: 0.5)
                    }
            }
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
    
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(transaction.iconColor.opacity(0.2))
                .frame(width: 40, height: 40)
            
            Circle()
                .strokeBorder(transaction.iconColor.opacity(0.4), lineWidth: 1)
                .frame(width: 40, height: 40)
            
            Image(systemName: transaction.iconName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(transaction.iconColor)
        }
    }
    
    private var transactionInfo: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(transaction.description)
                .font(AppFonts.body)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
            
            Text("\(transaction.category) • \(transaction.formattedDate)")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var amountView: some View {
        Text(transaction.formattedAmount)
            .font(AppFonts.body)
            .fontWeight(.semibold)
            .foregroundStyle(transaction.type == .income ? AppColors.success : transaction.iconColor)
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

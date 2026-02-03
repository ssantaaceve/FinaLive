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
    
    init(transaction: Transaction, onTap: (() -> Void)? = nil) {
        self.transaction = transaction
        self.onTap = onTap
    }
    
    // MARK: - Helper Types
    
    private var categoryStyle: (icon: String, color: Color) {
        CategoryMapper.styleForCategory(transaction.category)
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 16) {
                // 1. Icono de Categoría
                ZStack {
                    Circle()
                        .fill(categoryStyle.color.opacity(0.25)) // Mayor contraste (0.15 -> 0.25)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: categoryStyle.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(categoryStyle.color)
                }
                
                // 2. Información
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.description ?? transaction.category)
                        .font(AppFonts.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary) // Blanco Brillante
                        .lineLimit(1)
                        .truncationMode(.tail) // Cortar con "..." si es largo
                    
                    Text(transaction.formattedDate)
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary) // Gris
                }
                
                Spacer(minLength: 8) // Espacio mínimo para que no se peguen
                
                // 3. Monto
                Text(transaction.formattedAmount)
                    .font(AppFonts.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(transaction.type == .income ? AppColors.success : AppColors.error)
                    .lineLimit(1) // Obligatorio una sola línea
                    .minimumScaleFactor(0.7) // Reduce tamaño si no cabe
                    .layoutPriority(1) // Prioridad sobre la descripción
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(LiquidRowButtonStyle())
    }
    // Eliminar extensiones antiguas si existen
}

struct LiquidRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Color.white.opacity(configuration.isPressed ? 0.05 : 0.001)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
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

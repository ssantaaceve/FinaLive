//
//  CategoryMapper.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import SwiftUI

struct CategoryMapper {
    
    static func mapToDistribution(transactions: [Transaction]) -> [CategoryDistributionItem] {
        // 1. Filtrar solo gastos (Expense)
        let expenses = transactions.filter { $0.type == .expense }
        
        // 2. Agrupar por categoría
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        
        // 3. Crear items de distribución
        var items: [CategoryDistributionItem] = []
        
        for (categoryName, categoryTransactions) in grouped {
            let totalAmount = categoryTransactions.reduce(Decimal(0)) { $0 + $1.amount }
            let style = styleForCategory(categoryName)
            
            let item = CategoryDistributionItem(
                name: categoryName,
                amount: totalAmount,
                icon: style.icon,
                color: style.color
            )
            items.append(item)
        }
        
        // 4. Ordenar descendente por monto
        return items.sorted { $0.amount > $1.amount }
    }
    
    // Configuración de Estilo por Categoría
    static func styleForCategory(_ category: String) -> (icon: String, color: Color) {
        switch category {
        case "Vivienda y Servicios":
            return ("house.fill", Color.blue)
        case "Alimentación":
            return ("cart.fill", Color.orange)
        case "Transporte":
            return ("car.fill", Color.indigo)
        case "Compras Personales":
            return ("bag.fill", Color.pink)
        case "Salud y Bienestar":
            return ("heart.fill", Color.red)
        case "Ocio y Vida Social":
            return ("popcorn.fill", Color.purple)
        case "Educación y Desarrollo":
            return ("book.fill", Color.teal)
        case "Finanzas y Obligaciones", "Finanzas":
            return ("banknote.fill", Color.green)
        case "Otro", "Otros":
            return ("ellipsis.circle.fill", Color.gray)
        default:
            return ("questionmark.circle.fill", Color.secondary)
        }
    }
}

//
//  Transaction.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import Foundation
import SwiftUI

/// Modelo de transacción para la app
/// Modelo de transacción para la app
struct Transaction: Identifiable, Codable {
    let id: UUID
    let type: TransactionType
    let category: String
    let description: String? // Opcional en BD
    let amount: Decimal
    let date: Date
    
    // Necesario para decodificar string "income"/"expense" de la BD
    enum TransactionType: String, Codable {
        case income
        case expense
    }
    
    // Mapeo entre Swift (camelCase) y Supabase (snake_case)
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case category
        case description
        case amount
        case date
        // user_id lo manejamos en el repositorio, no necesariamente aquí si no se usa en UI
    }
    
    // Init personalizado para facilitar previews y mocks
    init(id: UUID = UUID(), type: TransactionType, category: String, description: String? = nil, amount: Decimal, date: Date) {
        self.id = id
        self.type = type
        self.category = category
        self.description = description
        self.amount = amount
        self.date = date
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        // Decimal converso a NSDecimalNumber para formateo
        let formatted = formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
        return (type == .income ? "+" : "-") + formatted
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return "Hoy, \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "HH:mm"
            return "Ayer, \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "d MMM"
            return formatter.string(from: date)
        }
    }
    
    var iconName: String {
        switch category.lowercased() {
        case "compras", "supermercado":
            return "bag.fill"
        case "alimentación", "café":
            return "cup.and.saucer.fill"
        case "salario", "trabajo":
            return "briefcase.fill"
        case "servicios", "arriendo", "hogar":
            return "house.fill"
        case "transporte":
            return "car.fill"
        case "entretenimiento":
            return "tv.fill"
        default:
            return type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill"
        }
    }
    
    var iconColor: Color {
        if type == .income {
            return AppColors.success
        }
        
        // Colores específicos por categoría para gastos
        switch category.lowercased() {
        case "alimentación", "café":
            return AppColors.warning
        default:
            return AppColors.error
        }
    }
}

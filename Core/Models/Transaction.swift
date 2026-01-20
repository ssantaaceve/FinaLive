//
//  Transaction.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import Foundation
import SwiftUI

/// Modelo de transacción para la app
struct Transaction: Identifiable {
    let id = UUID()
    let type: TransactionType
    let category: String
    let description: String
    let amount: Double
    let date: Date
    
    enum TransactionType {
        case income
        case expense
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let formatted = formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
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

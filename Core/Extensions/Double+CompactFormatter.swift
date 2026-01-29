//
//  Double+CompactFormatter.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 29/1/2026.
//

import Foundation

extension Double {
    /// Formatea el número a un string compacto estilo "Spanish Financial"
    /// Ejemplos:
    /// 3,500,000 -> "3.5 Mill"
    /// 100,000 -> "100 K"
    /// 1500 -> "1.5 K"
    /// 500 -> "500"
    func formatCompact(currencySymbol: String = "$") -> String {
        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch absValue {
        case 1_000_000...:
            let formatted = String(format: "%.1f", absValue / 1_000_000)
                .replacingOccurrences(of: ".0", with: "")
            return "\(sign)\(currencySymbol)\(formatted) Mill"
            
        case 1_000...:
            let formatted = String(format: "%.1f", absValue / 1_000)
                .replacingOccurrences(of: ".0", with: "")
            return "\(sign)\(currencySymbol)\(formatted) K"
            
        default:
            // Formato estándar para números pequeños
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = currencySymbol
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: self)) ?? "\(sign)\(currencySymbol)\(self)"
        }
    }
}

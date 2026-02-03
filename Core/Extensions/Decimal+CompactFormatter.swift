//
//  Decimal+CompactFormatter.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

extension Decimal {
    /// Formatea el número a un string compacto usando la extensión de Double
    func formatCompact(currencySymbol: String = "$") -> String {
        let doubleValue = NSDecimalNumber(decimal: self).doubleValue
        return doubleValue.formatCompact(currencySymbol: currencySymbol)
    }
}

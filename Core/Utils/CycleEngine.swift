//
//  CycleEngine.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

/// Motor lógico para cálculos de ciclos financieros
struct CycleEngine {
    
    /// Calcula el rango de fechas del ciclo financiero actual.
    /// - Parameters:
    ///   - startDay: Día del mes en que inicia el ciclo (1-31).
    ///   - referenceDate: Fecha de referencia (por defecto hoy).
    /// - Returns: Tupla con fecha de inicio y fin del ciclo.
    static func calculateCurrentCycle(startDay: Int, referenceDate: Date = Date()) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let dayOfReference = calendar.component(.day, from: referenceDate)
        
        var startComponents = calendar.dateComponents([.year, .month], from: referenceDate)
        startComponents.day = min(startDay, daysInMonth(for: referenceDate)) // Manejo básico de días inválidos (ej: 31 feb)
        
        // Determinar si el ciclo inició este mes o el anterior
        if dayOfReference < startDay {
            // Estamos antes del día de corte, el ciclo empezó el mes pasado
            // Restamos 1 mes a la fecha base
            if let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: referenceDate) {
                startComponents = calendar.dateComponents([.year, .month], from: prevMonthDate)
                startComponents.day = min(startDay, daysInMonth(for: prevMonthDate))
            }
        }
        
        // Fecha de inicio calculada
        guard let startDate = calendar.date(from: startComponents) else {
            return (referenceDate, referenceDate) // Fallback seguro
        }
        
        // Fecha fin es el día antes del inicio del siguiente ciclo
        // Sumamos 1 mes al inicio y restamos 1 día
        guard let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: startDate),
              let endDate = calendar.date(byAdding: .day, value: -1, to: nextMonthStart) else {
            return (startDate, startDate)
        }
        
        // Ajustar endDate al final del día (23:59:59) para incluir transacciones de ese día
        let finalEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        
        return (startDate, finalEndDate)
    }
    
    /// Filtra transacciones dentro de un rango de fechas.
    static func filterTransactions(_ transactions: [Transaction], in cycle: (start: Date, end: Date)) -> [Transaction] {
        return transactions.filter { transaction in
            transaction.date >= cycle.start && transaction.date <= cycle.end
        }
    }
    
    /// Devuelve un String legible del ciclo (ej: "15 Ene - 14 Feb")
    static func formatCycleDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CO") // O Locale.current
        formatter.dateFormat = "d MMM"
        
        let startString = formatter.string(from: start)
        let endString = formatter.string(from: end)
        
        return "\(startString.capitalized) - \(endString.capitalized)"
    }
    
    // MARK: - Helpers
    
    /// Retorna cuántos días tiene el mes de una fecha dada
    private static func daysInMonth(for date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 30
    }
}

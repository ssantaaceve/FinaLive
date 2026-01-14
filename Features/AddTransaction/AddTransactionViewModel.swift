//
//  AddTransactionViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation

/// ViewModel para agregar una nueva transacción
/// Maneja la lógica de validación y guardado de transacciones
@MainActor
class AddTransactionViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var description: String = ""
    @Published var isIncome: Bool = true
    @Published var isSaving: Bool = false
    
    var isValid: Bool {
        guard !amount.isEmpty,
              let amountValue = Double(amount) else {
            return false
        }
        return amountValue > 0
    }
    
    var numericAmount: Double? {
        Double(amount)
    }
    
    func saveTransaction() {
        guard isValid else { return }
        
        // TODO: Implementar guardado de transacción en servicio
        // Por ahora solo validamos
        
        clearForm()
    }
    
    private func clearForm() {
        amount = ""
        description = ""
        isIncome = true
        isSaving = false
    }
}

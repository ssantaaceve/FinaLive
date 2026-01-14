//
//  AddTransactionViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation
import SwiftUI

/// ViewModel para agregar una nueva transacción
/// Maneja la lógica de validación y guardado de transacciones
class AddTransactionViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var description: String = ""
    @Published var isIncome: Bool = true
    @Published var isSaving: Bool = false
    
    var isValid: Bool {
        !amount.isEmpty && Double(amount) != nil
    }
    
    func saveTransaction() {
        guard isValid else { return }
        
        // TODO: Implementar guardado de transacción
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

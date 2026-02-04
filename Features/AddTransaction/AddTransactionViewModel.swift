//
//  AddTransactionViewModel.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import SwiftUI
import Combine

@MainActor
class AddTransactionViewModel: ObservableObject {
    // MARK: - Dependencies
    private let repository: TransactionRepositoryProtocol
    
    // MARK: - Form State
    @Published var category: String = ""
    @Published var amount: String = ""        // Valor formateado para mostrar ($10.000,00)
    @Published var rawAmount: String = ""     // Valor crudo para lógica (10000)
    @Published var description: String = ""
    @Published var date: Date = Date()
    
    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Init
    init(repository: TransactionRepositoryProtocol = SupabaseTransactionRepository()) {
        self.repository = repository
    }
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        !category.isEmpty &&
        !rawAmount.isEmpty &&
        getNumericValue(from: rawAmount) > 0 &&
        !description.isEmpty
    }
    
    // MARK: - Business Logic
    
    /// Actualiza el monto crudo y genera el formato visual correspondiente
    func updateAmount(_ input: String) {
        // Filtrar solo números
        let numbersOnly = input.filter { $0.isNumber }
        self.rawAmount = numbersOnly
        
        if numbersOnly.isEmpty {
            self.amount = ""
        } else {
            self.amount = formatColombianCurrency(numbersOnly)
        }
    }
    
    /// Guarda la transacción usando el estado actual del ViewModel
    func saveTransaction(type: Transaction.TransactionType, onSuccess: @escaping () -> Void) async {
        guard isFormValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        let numericAmount = getNumericValue(from: rawAmount)
        
        let newTransaction = Transaction(
            type: type,
            category: category,
            description: description,
            amount: Decimal(numericAmount),
            date: date
        )
        
        do {
            try await repository.createTransaction(newTransaction)
            // Notificar que hubo cambios para que recarguen datos
            NotificationCenter.default.post(name: .didUpdateTransactions, object: nil)
            
            // Solicitar permisos de notificación (Solo la primera vez)
            // Esto asegura onboarding progresivo tras una acción de valor
            if !UserDefaults.standard.bool(forKey: "hasRequestedNotificationPermission") {
                NotificationManager.shared.requestAuthorization()
            }
            
            isLoading = false
            onSuccess()
        } catch {
            isLoading = false
            errorMessage = "Error al guardar: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Formatting Helpers
    
    private func getNumericValue(from rawValue: String) -> Double {
        guard !rawValue.isEmpty else { return 0 }
        // Los últimos 2 dígitos son decimales
        let totalValue = Double(rawValue) ?? 0
        return totalValue / 100.0
    }
    
    private func formatColombianCurrency(_ numbersOnly: String) -> String {
        guard !numbersOnly.isEmpty else { return "" }
        
        if numbersOnly.count == 1 { return "0,0\(numbersOnly)" }
        if numbersOnly.count == 2 { return "0,\(numbersOnly)" }
        
        let decimalPart = String(numbersOnly.suffix(2))
        let integerPart = String(numbersOnly.dropLast(2))
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        
        let integerValue = Int(integerPart) ?? 0
        let formattedInteger = formatter.string(from: NSNumber(value: integerValue)) ?? integerPart
        
        return "\(formattedInteger),\(decimalPart)"
    }
}

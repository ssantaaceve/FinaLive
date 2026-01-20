//
//  HomeViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation

/// ViewModel para la pantalla principal
/// Maneja la lógica de presentación de datos y acciones del usuario
@MainActor
class HomeViewModel: ObservableObject {
    @Published var balance: Double = 0.0
    @Published var income: Double = 0.0
    @Published var expense: Double = 0.0
    @Published var percentageChange: String = ""
    @Published var isLoading: Bool = false
    @Published var userName: String = "Sergio"
    @Published var hasNotifications: Bool = false
    
    init() {
        loadData()
    }
    
    var formattedBalance: String {
        formatCurrency(balance)
    }
    
    var formattedIncome: String {
        formatCurrency(income)
    }
    
    var formattedExpense: String {
        formatCurrency(expense)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    func loadData() {
        // TODO: Cargar datos de transacciones desde servicio
        // Valores mock para desarrollo visual
        balance = 15420.50
        income = 2500.00
        expense = 1249.50
        percentageChange = "+2.5% vs mes anterior"
        isLoading = false
    }
    
    func refreshAsync() async {
        isLoading = true
        // Simular carga asíncrona
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadData()
    }
}

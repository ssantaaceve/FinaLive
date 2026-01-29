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
    @Published var goals: [GoalsProgressCardView.Goal] = []
    @Published var recentTransactions: [Transaction] = []
    
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
        
        // Metas mock
        goals = [
            GoalsProgressCardView.Goal(
                name: "Viaje a Europa",
                currentAmount: 2500.0,
                targetAmount: 5000.0,
                icon: "airplane",
                reward: "Bono de Viaje $200k"
            ),
            GoalsProgressCardView.Goal(
                name: "Fondo de emergencia",
                currentAmount: 3200.0,
                targetAmount: 10000.0,
                icon: "shield.fill",
                reward: "Tasa Preferencial"
            ),
            GoalsProgressCardView.Goal(
                name: "Renovación del hogar",
                currentAmount: 800.0,
                targetAmount: 3000.0,
                icon: "house.fill",
                reward: "Decoración Premium"
            )
        ]
        
        // Transacciones recientes mock
        let now = Date()
        recentTransactions = [
            Transaction(
                type: .expense,
                category: "Compras",
                description: "Supermercado",
                amount: 125.50,
                date: now
            ),
            Transaction(
                type: .expense,
                category: "Alimentación",
                description: "Café y desayuno",
                amount: 15.00,
                date: Calendar.current.date(byAdding: .hour, value: -5, to: now) ?? now
            ),
            Transaction(
                type: .income,
                category: "Salario",
                description: "Pago quincenal",
                amount: 2500.00,
                date: Calendar.current.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            Transaction(
                type: .expense,
                category: "Servicios",
                description: "Arriendo",
                amount: 800.00,
                date: Calendar.current.date(byAdding: .day, value: -5, to: now) ?? now
            )
        ]
        
        isLoading = false
    }
    
    func refreshAsync() async {
        isLoading = true
        // Simular carga asíncrona
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadData()
    }
}

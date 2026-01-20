//
//  IncomesExpensesViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import Foundation

/// ViewModel para la pantalla de Ingresos y Gastos
/// Maneja la lógica de presentación de movimientos y acciones del usuario
@MainActor
class IncomesExpensesViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading: Bool = false
    
    init() {
        loadTransactions()
    }
    
    func loadTransactions() {
        // TODO: Cargar transacciones desde servicio
        // Datos mock para desarrollo visual
        let now = Date()
        let calendar = Calendar.current
        
        transactions = [
            Transaction(
                type: .income,
                category: "Salario",
                description: "Pago quincenal",
                amount: 2500.00,
                date: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
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
                date: calendar.date(byAdding: .hour, value: -5, to: now) ?? now
            ),
            Transaction(
                type: .expense,
                category: "Servicios",
                description: "Arriendo",
                amount: 800.00,
                date: calendar.date(byAdding: .day, value: -5, to: now) ?? now
            ),
            Transaction(
                type: .income,
                category: "Freelance",
                description: "Proyecto web",
                amount: 500.00,
                date: calendar.date(byAdding: .day, value: -3, to: now) ?? now
            ),
            Transaction(
                type: .expense,
                category: "Transporte",
                description: "Uber",
                amount: 25.00,
                date: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            )
        ].sorted { $0.date > $1.date } // Más recientes primero
        
        isLoading = false
    }
    
    func refreshAsync() async {
        isLoading = true
        // Simular carga asíncrona
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadTransactions()
    }
}

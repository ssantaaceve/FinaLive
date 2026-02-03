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
    private let transactionRepository: TransactionRepositoryProtocol
    
    @Published var balance: Decimal = 0.0
    @Published var income: Decimal = 0.0
    @Published var expense: Decimal = 0.0
    @Published var percentageChange: String = ""
    @Published var isLoading: Bool = false
    @Published var userName: String = "Sergio" // TODO: Cargar del perfil real
    @Published var hasNotifications: Bool = false
    @Published var goals: [GoalsProgressCardView.Goal] = []
    @Published var recentTransactions: [Transaction] = []
    @Published var errorMessage: String?
    
    init(transactionRepository: TransactionRepositoryProtocol = SupabaseTransactionRepository()) {
        self.transactionRepository = transactionRepository
        
        // Suscribirse a cambios en transacciones para recarga automática
        NotificationCenter.default.addObserver(forName: .didUpdateTransactions, object: nil, queue: .main) { [weak self] _ in
            self?.loadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }
    
    func loadData() {
        Task {
            await refreshAsync()
        }
    }
    
    func refreshAsync() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let transactions = try await transactionRepository.fetchTransactions()
            self.recentTransactions = transactions
            calculateBalance(from: transactions)
            
            // TODO: Cargar metas reales
            loadMockGoals()
            
        } catch {
            errorMessage = "Error cargando datos: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func calculateBalance(from transactions: [Transaction]) {
        var newIncome: Decimal = 0
        var newExpense: Decimal = 0
        
        for transaction in transactions {
            if transaction.type == .income {
                newIncome += transaction.amount
            } else {
                newExpense += transaction.amount
            }
        }
        
        self.income = newIncome
        self.expense = newExpense
        self.balance = newIncome - newExpense
        
        // Simulado por ahora
        self.percentageChange = "+0% vs mes anterior"
    }
    
    private func loadMockGoals() {
        // Metas mock temporales hasta que migremos Goals
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
            )
        ]
    }
}

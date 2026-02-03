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
    private let userRepository: UserRepositoryProtocol
    
    @Published var balance: Decimal = 0.0
    @Published var income: Decimal = 0.0
    @Published var expense: Decimal = 0.0
    @Published var percentageChange: String = ""
    @Published var isLoading: Bool = false
    @Published var userName: String = "Usuario"
    @Published var hasNotifications: Bool = false
    @Published var goals: [GoalsProgressCardView.Goal] = []
    @Published var recentTransactions: [Transaction] = []
    @Published var categoryDistributions: [CategoryDistributionItem] = [] // Data Viz Data
    @Published var errorMessage: String?
    
    // Estados de Ciclo
    @Published var currentCycleRange: String = ""
    @Published var cycleStartDay: Int = 1
    
    init(
        transactionRepository: TransactionRepositoryProtocol = SupabaseTransactionRepository(),
        userRepository: UserRepositoryProtocol = SupabaseUserRepository()
    ) {
        self.transactionRepository = transactionRepository
        self.userRepository = userRepository
        
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
            // 1. Cargar Perfil para saber el día de corte
            let profile = try await userRepository.fetchUserProfile()
            self.cycleStartDay = profile.cycleStartDay
            
            // 2. Calcular Ciclo Actual
            let cycle = CycleEngine.calculateCurrentCycle(startDay: cycleStartDay)
            self.currentCycleRange = CycleEngine.formatCycleDateRange(start: cycle.start, end: cycle.end)
            
            // 3. Cargar Transacciones
            let allTransactions = try await transactionRepository.fetchTransactions()
            self.recentTransactions = allTransactions
            
            // 4. Calcular Balance Filtrado por Ciclo
            calculateBalance(from: allTransactions, in: cycle)
            
            // TODO: Cargar metas reales
            loadMockGoals()
            
        } catch {
            errorMessage = "Error cargando datos: \(error.localizedDescription)"
            print("Error detallado: \(error)")
        }
        
        isLoading = false
    }
    
    func deleteTransaction(_ transaction: Transaction) async {
        // Optimistic UI Update: Eliminar inmediatamente de la lista local
        /* 
           Nota: Si hay muchas transacciones, filtrar todo el array puede ser O(n).
           Para 10-50 items está bien.
        */
        guard let index = recentTransactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        let deletedItem = recentTransactions.remove(at: index)
        
        // Recalcular localmente para feedback inmediato
        let cycle = CycleEngine.calculateCurrentCycle(startDay: cycleStartDay)
        calculateBalance(from: recentTransactions, in: cycle)
        
        do {
            try await transactionRepository.deleteTransaction(id: transaction.id)
            print("Transaction deleted successfully: \(transaction.id)")
        } catch {
            print("Error deleting transaction: \(error)")
            errorMessage = "No se pudo eliminar: \(error.localizedDescription)"
            
            // Revertir (Rollback) si falla
            recentTransactions.insert(deletedItem, at: index)
            calculateBalance(from: recentTransactions, in: cycle)
        }
    }
    
    private func calculateBalance(from transactions: [Transaction], in cycle: (start: Date, end: Date)) {
        // Filtramos las transacciones que pertenecen a ESTE ciclo
        let cycleTransactions = CycleEngine.filterTransactions(transactions, in: cycle)
        
        // Data Viz: Calculamos distribución de gastos
        self.categoryDistributions = CategoryMapper.mapToDistribution(transactions: cycleTransactions)
        
        var newIncome: Decimal = 0
        var newExpense: Decimal = 0
        var totalBalance: Decimal = 0 // El balance total suele ser histórico, pero aquí calculamos cashflow del ciclo
        
        // Calculamos Cashflow del Ciclo
        for transaction in cycleTransactions {
            if transaction.type == .income {
                newIncome += transaction.amount
            } else {
                newExpense += transaction.amount
            }
        }
        
        // Balance histórico (opcional, si queremos mostrar patrimonio neto en vez de cashflow del mes)
        // Por ahora, mostraremos el "Dinero Libre" del periodo (Ingresos - Gastos del ciclo)
        // Si el usuario prefiere "Saldo en Cuenta", deberíamos sumar TODO el historial.
        // Estrategia: Balance Grande = Patrimonio (Todo el historial). Ingresos/Gastos = Ciclo.
        
        var historicalBalance: Decimal = 0
        for transaction in transactions {
             if transaction.type == .income {
                historicalBalance += transaction.amount
            } else {
                historicalBalance += transaction.amount // Amount es negativo para gastos? Verificar Transaction Model.
                // En Transaction model: amount es Decimal positivo, type define signo.
                // Pero wait, si amount es positivo siempre, entonces:
                historicalBalance -= transaction.type == .expense ? transaction.amount : 0
            }
        }
        // Corrección: Como calculé arriba 'newExpense' sumando positivos, aquí resto.
        
        self.income = newIncome
        self.expense = newExpense
        
        // Decisión de Producto: ¿Qué mostramos en "Balance Total"?
        // Opción A: Lo que queda del mes (Ingresos Ciclo - Gastos Ciclo).
        // Opción B: Saldo Real en banco (Histórico).
        // Dado que es un "Dashboard de Ciclo", suele ser más útil "Cuánto me queda este mes".
        // Pero el label dice "Balance Total".
        // Vamos a mostrar el Cashflow del Ciclo como Balance Principal para que cuadre con las cápsulas.
        self.balance = newIncome - newExpense
        
        // Simulado por ahora
        self.percentageChange = "Ciclo actual"
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

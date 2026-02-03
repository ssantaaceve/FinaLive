//
//  AllTransactionsViewModel.swift
//  FinaLive
//
//  Created by FinaLive Architect on 03/02/2026.
//

import Foundation

@MainActor
class AllTransactionsViewModel: ObservableObject {
    private let repository: TransactionRepositoryProtocol
    
    @Published var transactions: [Transaction] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    enum TransactionTypeFilter: String, CaseIterable, Identifiable {
        case all = "Todos"
        case income = "Ingresos"
        case expense = "Gastos"
        
        var id: String { rawValue }
    }
    
    // Filtros
    @Published var selectedFilter: TransactionTypeFilter = .all
    
    // Filtro derivado
    var filteredTransactions: [Transaction] {
        let textFiltered: [Transaction]
        if searchText.isEmpty {
            textFiltered = transactions
        } else {
            textFiltered = transactions.filter { transaction in
                let matchesDescription = (transaction.description ?? "").localizedCaseInsensitiveContains(searchText)
                let matchesCategory = transaction.category.localizedCaseInsensitiveContains(searchText)
                return matchesDescription || matchesCategory
            }
        }
        
        switch selectedFilter {
        case .all:
            return textFiltered
        case .income:
            return textFiltered.filter { $0.type == .income }
        case .expense:
            return textFiltered.filter { $0.type == .expense }
        }
    }
    
    // Agrupación por Fecha
    var groupedTransactions: [(key: Date, value: [Transaction])] {
        let grouped = Dictionary(grouping: filteredTransactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    // Total filtrado (Opcional Delight)
    var filteredTotal: Decimal {
        filteredTransactions.reduce(0) { result, transaction in
            if transaction.type == .income {
                return result + transaction.amount
            } else {
                return result - transaction.amount
            }
        }
    }
    
    // Estado de eliminación individual (para Swipe personalizado)
    @Published var transactionToDelete: Transaction?
    @Published var showDeleteAlert: Bool = false
    
    init(repository: TransactionRepositoryProtocol = SupabaseTransactionRepository()) {
        self.repository = repository
    }
    
    func loadTransactions() async {
        isLoading = true
        errorMessage = nil
        do {
            transactions = try await repository.fetchTransactions()
        } catch {
            errorMessage = "Error cargando: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func deleteImmediately(_ transaction: Transaction) {
        // Optimistic Update
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions.remove(at: index)
        }
        
        Task {
            do {
                try await repository.deleteTransaction(id: transaction.id)
                NotificationCenter.default.post(name: .didUpdateTransactions, object: nil)
            } catch {
                errorMessage = "Error eliminando: \(error.localizedDescription)"
                await loadTransactions() // Rollback
            }
        }
    }
    
    // Legacy / Unused now
    func confirmDelete(_ transaction: Transaction) {
        self.transactionToDelete = transaction
        self.showDeleteAlert = true
    }
    
    func deleteConfirmedTransaction() {
        guard let transaction = transactionToDelete else { return }
        
        // Optimistic Update
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions.remove(at: index)
        }
        
        Task {
            do {
                try await repository.deleteTransaction(id: transaction.id)
                NotificationCenter.default.post(name: .didUpdateTransactions, object: nil)
            } catch {
                errorMessage = "Error eliminando: \(error.localizedDescription)"
                await loadTransactions() // Rollback
            }
            // Reset state
            transactionToDelete = nil
        }
    }

    // Deprecated: used for List.onDelete
    func deleteTransaction(at offsets: IndexSet) {
        // Mapear indices filtrados a indices reales es complejo si borramos directo del filtrado.
        // SwiftUI List .onDelete nos da indices relativos a lo mostrado.
        // Si mostramos `filteredTransactions`, el index es de ese array.
        
        for index in offsets {
            guard index < filteredTransactions.count else { continue }
            let transactionToDelete = filteredTransactions[index]
            
            // Optimistic Update en lista principal
            if let mainIndex = transactions.firstIndex(where: { $0.id == transactionToDelete.id }) {
                transactions.remove(at: mainIndex)
            }
            
            Task {
                do {
                    try await repository.deleteTransaction(id: transactionToDelete.id)
                    // Notificar a Home para que recargue y actualice balance
                    NotificationCenter.default.post(name: .didUpdateTransactions, object: nil)
                } catch {
                    // Rollback? Complicado. Mostramos error.
                    errorMessage = "Error eliminando: \(error.localizedDescription)"
                    await loadTransactions() // Recargar para sincronizar
                }
            }
        }
    }
}

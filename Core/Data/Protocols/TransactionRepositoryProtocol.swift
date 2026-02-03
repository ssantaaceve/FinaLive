//
//  TransactionRepositoryProtocol.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

protocol TransactionRepositoryProtocol {
    /// Obtiene las transacciones del usuario
    func fetchTransactions() async throws -> [Transaction]
    
    /// Crea una nueva transacción
    func createTransaction(_ transaction: Transaction) async throws
    
    /// Elimina una transacción
    func deleteTransaction(id: UUID) async throws
    
    /// Obtiene el balance calculado (opcional, si usamos vista SQL)
    /// func fetchBalance() async throws -> Double
}

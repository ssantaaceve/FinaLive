//
//  SupabaseTransactionRepository.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation
import Supabase

class SupabaseTransactionRepository: TransactionRepositoryProtocol {
    
    // Cliente singleton
    private let client = SupabaseService.shared.client
    
    func fetchTransactions() async throws -> [Transaction] {
        // Obtenemos el ID del usuario actual
        guard let currentUserId = client.auth.currentUser?.id else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No hay usuario logueado"])
        }
        
        let transactions: [Transaction] = try await client
            .from("transactions")
            .select() // Select *
            .eq("user_id", value: currentUserId)
            .order("date", ascending: false) // Más recientes primero
            .execute()
            .value
        
        return transactions
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        guard let currentUserId = client.auth.currentUser?.id else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No hay usuario logueado"])
        }
        
        // Creamos un diccionario o struct encodable que incluya user_id
        // Como Transaction no tiene user_id, creamos un DTO intermedio o insertamos manualmente
        
        struct CreateTransactionDTO: Encodable {
            let user_id: UUID
            let type: Transaction.TransactionType
            let category: String
            let description: String?
            let amount: Decimal
            let date: Date
        }
        
        let dto = CreateTransactionDTO(
            user_id: currentUserId,
            type: transaction.type,
            category: transaction.category,
            description: transaction.description,
            amount: transaction.amount,
            date: transaction.date
        )
        
        try await client
            .from("transactions")
            .insert(dto)
            .execute()
    }
    
    func deleteTransaction(id: UUID) async throws {
        try await client
            .from("transactions")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}

//
//  SupabaseAuthRepository.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation
import Supabase

/// Implementación real usando el SDK de Supabase
class SupabaseAuthRepository: AuthRepositoryProtocol {
    
    // Usamos el singleton que creamos antes
    private let client = SupabaseService.shared.client
    
    func signIn(email: String, password: String) async throws {
        _ = try await client.auth.signIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws {
        _ = try await client.auth.signUp(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUser() async -> Bool {
        // Verificamos si hay una sesión activa
        do {
            _ = try await client.auth.session
            return true
        } catch {
            return false
        }
    }
}

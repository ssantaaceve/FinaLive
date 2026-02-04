//
//  SupabaseService.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    // El cliente principal de Supabase
    let client: SupabaseClient
    
    // Inicializador privado para garantizar Singleton
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: AppConfig.supabaseUrl)!,
            supabaseKey: AppConfig.supabaseAnonKey
        )
    }
    
    // Check for active session
    func hasActiveSession() async -> Bool {
        do {
            _ = try await client.auth.session
            return true
        } catch {
            return false
        }
    }
}

//
//  AuthRepositoryProtocol.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

/// Contrato que define qué puede hacer el sistema de autenticación.
/// Los ViewModels solo conocen est protocolo, no saben si es Supabase o Firebase.
protocol AuthRepositoryProtocol {
    /// Inicia sesión con correo y contraseña
    func signIn(email: String, password: String) async throws
    
    /// Registra un nuevo usuario
    func signUp(email: String, password: String) async throws
    
    /// Cierra la sesión actual
    func signOut() async throws
    
    /// Verifica si hay un usuario logueado actualmente
    func getCurrentUser() async -> Bool
}

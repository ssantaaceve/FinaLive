//
//  AuthViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import Foundation

/// ViewModel para la autenticación
/// Maneja la lógica de login, sign up y validaciones
@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var authMode: AuthMode = .login
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Login Properties
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    
    // MARK: - Sign Up Properties
    @Published var signUpName: String = ""
    @Published var signUpEmail: String = ""
    @Published var signUpPhone: String = ""
    @Published var signUpPassword: String = ""
    
    enum AuthMode {
        case login
        case signUp
    }
    
    // MARK: - Validation
    
    var isLoginValid: Bool {
        !loginEmail.isEmpty && !loginPassword.isEmpty
    }
    
    var isSignUpValid: Bool {
        !signUpName.isEmpty &&
        !signUpEmail.isEmpty &&
        !signUpPhone.isEmpty &&
        !signUpPassword.isEmpty
    }
    
    // MARK: - Actions
    
    func toggleAuthMode() {
        authMode = authMode == .login ? .signUp : .login
        clearError()
    }
    
    func login() async {
        guard isLoginValid else {
            errorMessage = "Por favor completa todos los campos"
            return
        }
        
        clearError()
        isLoading = true
        
        // TODO: Implementar login con Supabase
        // Por ahora solo simulamos
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
        // En el futuro: navegar a home o manejar error
    }
    
    func signUp() async {
        guard isSignUpValid else {
            errorMessage = "Por favor completa todos los campos"
            return
        }
        
        clearError()
        isLoading = true
        
        // TODO: Implementar sign up con Supabase
        // Por ahora solo simulamos
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
        // En el futuro: navegar a home o manejar error
    }
    
    func signInWithApple() async {
        clearError()
        isLoading = true
        
        // TODO: Implementar Apple Sign In
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
    }
    
    // MARK: - Private
    
    private func clearError() {
        errorMessage = nil
    }
}

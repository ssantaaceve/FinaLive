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
    // MARK: - Properties
    
    weak var router: AppRouter?
    private let authRepository: AuthRepositoryProtocol
    
    // MARK: - Published Properties
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(router: AppRouter?, authRepository: AuthRepositoryProtocol = SupabaseAuthRepository()) {
        self.router = router
        self.authRepository = authRepository
    }
    
    // MARK: - Auth Actions
    
    // TODO: Remover Apple Login simulado
    func handleAppleLogin() async {
        // Mantenemos esto por si la UI lo llama, pero redirige a signIn
        await signIn()
    }
    
    func signIn() async {
        guard validateInput() else { return }
        
        isLoading = true
        clearError()
        
        do {
            try await authRepository.signIn(email: email, password: password)
            isAuthenticated = true
            navigateToNextScreen()
        } catch {
            errorMessage = "Error al iniciar sesión: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func signUp() async {
        guard validateInput() else { return }
        
        isLoading = true
        clearError()
        
        do {
            try await authRepository.signUp(email: email, password: password)
            isAuthenticated = true
            navigateToNextScreen()
        } catch {
            errorMessage = "Error al registrarse: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Private Helpers
    
    private func validateInput() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Por favor completa todos los campos"
            return false
        }
        if password.count < 6 {
            errorMessage = "La contraseña debe tener al menos 6 caracteres"
            return false
        }
        return true
    }
    
    private func navigateToNextScreen() {
        Task {
            router?.navigateToOnboarding()
        }
    }
    
    // MARK: - Private
    
    private func clearError() {
        errorMessage = nil
    }
}

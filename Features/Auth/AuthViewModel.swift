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
    
    // MARK: - Published Properties
    

    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(router: AppRouter?) {
        self.router = router
    }
    
    // MARK: - Login Properties
    // Login se maneja exclusivamente con Apple ID / Keyless
    
    // MARK: - Actions
    
    // Login con Apple ID (Simulado para MVP)
    func handleAppleLogin() async {
        clearError()
        isLoading = true
        
        // Simulación de network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s
        
        isLoading = false
        isAuthenticated = true
        
        // Navegación vía Router
        // Nota: La vista reacciona a isAuthenticated o usa el closure, mantenemos ambos para flexibilidad
        await MainActor.run {
            router?.navigateToOnboarding()
        }
    }
    
    // MARK: - Private
    
    private func clearError() {
        errorMessage = nil
    }
}

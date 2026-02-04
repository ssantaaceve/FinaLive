//
//  AppRouter.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Router principal de la aplicación que maneja la navegación inicial
/// y decide qué vista mostrar basado en el estado de la app (ej: onboarding completado)
class AppRouter: ObservableObject {
    @Published var currentView: AppView = .auth
    
    init() {
        checkSession()
    }
    
    private func checkSession() {
        Task {
            // Verificar si hay sesión activa en Supabase
            if await SupabaseService.shared.hasActiveSession() {
                await MainActor.run {
                    self.currentView = .home
                }
            } else {
                await MainActor.run {
                    self.currentView = .auth
                }
            }
        }
    }
    
    @Published var presentedSheet: Sheet?
    @Published var isTabBarHidden: Bool = false
    
    enum AppView {
        case onboarding
        case auth
        case home
    }
    
    enum Sheet: Identifiable {
        case addExpense
        case addIncome
        
        var id: String {
            String(describing: self)
        }
    }
    
    func navigateToOnboarding() {
        currentView = .onboarding
    }
    
    func navigateToAuth() {
        currentView = .auth
    }
    
    func navigateToHome() {
        currentView = .home
    }
}

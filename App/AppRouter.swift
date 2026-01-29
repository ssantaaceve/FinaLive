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
    
    @Published var presentedSheet: Sheet?
    
    enum AppView {
        case onboarding
        case auth
        case home
    }
    
    enum Sheet: Identifiable {
        case addExpense
        case addIncome
        
        var id: Int {
            hashValue
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

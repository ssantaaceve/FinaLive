//
//  OnboardingViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation
import SwiftUI

/// ViewModel para la pantalla de onboarding
/// Maneja la lógica de presentación y navegación después del onboarding
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    let totalPages: Int = 3
    
    func nextPage() {
        if currentPage < totalPages - 1 {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    func completeOnboarding() {
        // TODO: Guardar estado de onboarding completado (UserDefaults, etc.)
        // Por ahora solo navegamos a home
    }
}

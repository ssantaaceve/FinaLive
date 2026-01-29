//
//  OnboardingViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation
import SwiftUI

/// ViewModel para el onboarding de 3 pantallas
/// Maneja el estado de cada paso y la navegación
@MainActor

class OnboardingViewModel: ObservableObject {
    // MARK: - Navigation
    
    @Published var currentStep: Int = 0
    let totalSteps: Int = 4
    
    // MARK: - Step 4: Intereses (Final)
    
    @Published var selectedInterests: Set<OnboardingInterest> = []
    @Published var othersText: String = ""
    
    enum OnboardingInterest: String, CaseIterable, Identifiable {
        case travel = "Viajes"
        case education = "Educación"
        case finance = "Finanzas"
        case business = "Emprendimiento"
        case entertainment = "Entretenimiento"
        case sports = "Deporte"
        case other = "Otros"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .travel: return "airplane"
            case .education: return "book.fill"
            case .finance: return "chart.bar.fill"
            case .business: return "briefcase.fill"
            case .entertainment: return "tv.fill"
            case .sports: return "sportscourt.fill"
            case .other: return "star.fill"
            }
        }
    }
    
    // MARK: - Logic methods
    
    func toggleInterest(_ interest: OnboardingInterest) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
            // Si deseleccionamos 'Otros', limpiamos el texto
            if interest == .other {
                othersText = ""
            }
        } else {
            selectedInterests.insert(interest)
        }
    }
    
    // MARK: - Navigation Methods
    
    var canGoToNextStep: Bool {
        switch currentStep {
        case 0, 1, 2:
            return true // Pasos informativos
        case 3:
            if selectedInterests.isEmpty { return false }
            // Si seleccionó 'Otros', validamos que el texto no esté vacío
            if selectedInterests.contains(.other) && othersText.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
            return true
        default: return false
        }
    }
    
    func nextStep() {
        guard canGoToNextStep, currentStep < totalSteps - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }
    
    func previousStep() {
        guard currentStep > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep -= 1
        }
    }
    
    func completeOnboarding() {
        // TODO: Persistir datos de onboarding (Intereses) en Supabase
        print("Onboarding completado con intereses: \(selectedInterests)")
    }
}

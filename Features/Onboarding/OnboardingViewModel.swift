//
//  OnboardingViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation

/// ViewModel para el onboarding de 3 pantallas
/// Maneja el estado de cada paso y la navegación
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Navigation
    
    @Published var currentStep: Int = 0
    let totalSteps: Int = 3
    
    // MARK: - Step 1: Objetivo de ahorro
    
    @Published var selectedGoal: SavingsGoal?
    
    enum SavingsGoal: String, CaseIterable {
        case travel = "Viajes"
        case education = "Estudio"
        case entertainment = "Entretenimiento"
        case home = "Hogar"
        case transportation = "Transporte"
        case wellness = "Bienestar"
        case other = "Otro"
        
        var icon: String {
            switch self {
            case .travel: return "airplane"
            case .education: return "book"
            case .entertainment: return "tv"
            case .home: return "house"
            case .transportation: return "car"
            case .wellness: return "heart"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    // MARK: - Step 2: Meta de ahorro
    
    @Published var selectedAmountRange: AmountRange?
    
    enum AmountRange: String, CaseIterable {
        case low = "$100 – $300"
        case medium = "$300 – $600"
        case high = "$600 – $1,000"
        case veryHigh = "Más de $1,000"
        
        var minValue: Int {
            switch self {
            case .low: return 100
            case .medium: return 300
            case .high: return 600
            case .veryHigh: return 1000
            }
        }
    }
    
    // MARK: - Step 3: Incentivos
    
    @Published var selectedIncentive: Incentive?
    
    enum Incentive: String, CaseIterable {
        case discounts = "Descuentos relacionados con mi objetivo"
        case rewards = "Recompensas exclusivas"
        case achievements = "Logros / niveles"
        case none = "No me motiva"
        
        var icon: String {
            switch self {
            case .discounts: return "tag"
            case .rewards: return "gift"
            case .achievements: return "trophy"
            case .none: return "xmark.circle"
            }
        }
    }
    
    // MARK: - Navigation Methods
    
    var canGoToNextStep: Bool {
        switch currentStep {
        case 0: return selectedGoal != nil
        case 1: return selectedAmountRange != nil
        case 2: return selectedIncentive != nil
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
        // TODO: Persistir datos de onboarding
        // Por ahora solo almacenamos en memoria
    }
}

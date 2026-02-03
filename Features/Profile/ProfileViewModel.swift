//
//  ProfileViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 28/1/2026.
//

import Foundation
import SwiftUI

/// ViewModel para la pantalla de Perfil de Usuario
/// Maneja datos del usuario, gamificación y configuraciones
@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol
    
    // MARK: - User Info
    @Published var userName: String = "Sergio Andrés"
    @Published var userEmail: String = "sergio@example.com"
    @Published var memberSince: String = "Miembro desde 2026"
    @Published var userInitial: String = "S"
    
    // MARK: - Gamification Stats
    @Published var currentLevel: Int = 5
    @Published var currentPoints: Int = 1250
    @Published var nextLevelPoints: Int = 2000
    @Published var levelName: String = "Estratega Financiero"
    
    // MARK: - Settings State
    @Published var notificationsEnabled: Bool = true
    @Published var faceIDEnabled: Bool = false
    @Published var cycleStartDay: Int = 1 // Por defecto
    
    init(userRepository: UserRepositoryProtocol = SupabaseUserRepository()) {
        self.userRepository = userRepository
        Task { await loadProfile() }
    }
    
    // MARK: - Logic
    
    func loadProfile() async {
        do {
            let profile = try await userRepository.fetchUserProfile()
            self.cycleStartDay = profile.cycleStartDay
            // TODO: Cargar nombre real también si es necesario
        } catch {
            print("Error cargando perfil: \(error)")
        }
    }
    
    func updateCycleDay(_ day: Int) {
        Task {
            do {
                try await userRepository.updateCycleStartDay(day)
                self.cycleStartDay = day
                // Notificar a otras partes de la app para que recarguen
                NotificationCenter.default.post(name: .didUpdateTransactions, object: nil)
            } catch {
                print("Error actualizando ciclo: \(error)")
            }
        }
    }
    
    var progressToNextLevel: Double {
        return Double(currentPoints) / Double(nextLevelPoints)
    }
    
    func logout() {
        print("Cerrando sesión...")
        // Aquí iría la lógica real de logout
        Task {
            do {
                try await SupabaseService.shared.client.auth.signOut()
            } catch {
                print("Error saliendo: \(error)")
            }
        }
    }
    
    func toggleNotifications() {
        // Lógica para persistir preferencia
        print("Notificaciones: \(notificationsEnabled)")
    }
    
    func toggleFaceID() {
        // Lógica para activar/desactivar biometría
        print("FaceID: \(faceIDEnabled)")
    }
}

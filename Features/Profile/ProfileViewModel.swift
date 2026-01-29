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
    
    // MARK: - Logic
    
    var progressToNextLevel: Double {
        return Double(currentPoints) / Double(nextLevelPoints)
    }
    
    func logout() {
        print("Cerrando sesión...")
        // Aquí iría la lógica real de logout
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

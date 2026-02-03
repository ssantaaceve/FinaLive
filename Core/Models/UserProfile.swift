//
//  UserProfile.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

/// Modelo que representa el perfil de usuario en Supabase
/// Tabla: profiles
struct UserProfile: Codable, Identifiable {
    let id: UUID
    let email: String?
    let cycleStartDay: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case cycleStartDay = "cycle_start_day"
    }
    
    // Init por defecto para casos de uso local o mocks
    init(id: UUID, email: String? = nil, cycleStartDay: Int = 1) {
        self.id = id
        self.email = email
        self.cycleStartDay = cycleStartDay
    }
}

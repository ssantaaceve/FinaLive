//
//  SupabaseUserRepository.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation
import Supabase

class SupabaseUserRepository: UserRepositoryProtocol {
    private let client = SupabaseService.shared.client
    
    func fetchUserProfile() async throws -> UserProfile {
        let user = try await client.auth.session.user
        
        let profile: UserProfile = try await client
            .from("profiles")
            .select()
            .eq("id", value: user.id)
            .single()
            .execute()
            .value
            
        return profile
    }
    
    func updateCycleStartDay(_ day: Int) async throws {
        let user = try await client.auth.session.user
        
        try await client
            .from("profiles")
            .update(["cycle_start_day": day])
            .eq("id", value: user.id)
            .execute()
    }
}

//
//  UserRepositoryProtocol.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUserProfile() async throws -> UserProfile
    func updateCycleStartDay(_ day: Int) async throws
}

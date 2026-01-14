//
//  FinaLiveApp.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

@main
struct FinaLiveApp: App {
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            rootView
        }
    }
    
    @ViewBuilder
    private var rootView: some View {
        switch router.currentView {
        case .onboarding:
            OnboardingView(router: router)
        case .home:
            HomeView(router: router)
        }
    }
}

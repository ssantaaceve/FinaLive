//
//  AuthView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista principal de autenticación
/// Contenedor simple para LoginView (Single Entry Point)
struct AuthView: View {
    @ObservedObject var router: AppRouter
    
    // Mantenemos el ViewModel aquí para que viva mientras estemos en Auth
    @StateObject private var viewModel: AuthViewModel
    
    init(router: AppRouter) {
        self.router = router
        _viewModel = StateObject(wrappedValue: AuthViewModel(router: router))
    }
    
    var body: some View {
        LoginView(viewModel: viewModel) {
            router.navigateToOnboarding()
        }
    }
}

#Preview {
    AuthView(router: AppRouter())
}

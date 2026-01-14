//
//  OnboardingView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Vista de onboarding inicial de la aplicación
/// Muestra una introducción simple y permite navegar a la pantalla principal
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @ObservedObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
            
            VStack(spacing: 16) {
                Text("Bienvenido a FinaLive")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Gestiona tus finanzas de manera simple")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.completeOnboarding()
                router.navigateToHome()
            }) {
                Text("Comenzar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    OnboardingView(router: AppRouter())
}

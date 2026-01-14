//
//  AuthView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista principal de autenticación
/// Maneja el cambio entre Login y Sign Up
struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @ObservedObject var router: AppRouter
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    contentSection
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                }
                .frame(minHeight: geometry.size.height)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(AppColors.background)
        .safeAreaInset(edge: .bottom) {
            bottomSection
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea(edges: .bottom)
                }
        }
    }
    
    // MARK: - View Components
    
    private var contentSection: some View {
        VStack(spacing: AppSpacing.xl) {
            headerSection
            
            formSection
            
            dividerSection
            
            appleSignInSection
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(AppColors.primary.gradient)
            
            Text(viewModel.authMode == .login ? "Iniciar Sesión" : "Crear Cuenta")
                .font(AppFonts.title)
            
            Text("Bienvenido a FinaLive")
                .font(AppFonts.body)
                .foregroundStyle(.secondary)
        }
    }
    
    private var formSection: some View {
        Group {
            if viewModel.authMode == .login {
                LoginView(viewModel: viewModel)
            } else {
                SignUpView(viewModel: viewModel)
            }
        }
    }
    
    private var dividerSection: some View {
        HStack(spacing: AppSpacing.md) {
            Rectangle()
                .fill(.quaternary)
                .frame(height: 1)
            
            Text("o")
                .font(AppFonts.caption)
                .foregroundStyle(.secondary)
            
            Rectangle()
                .fill(.quaternary)
                .frame(height: 1)
        }
    }
    
    private var appleSignInSection: some View {
        AppleSignInButton {
            Task {
                await viewModel.signInWithApple()
            }
        }
    }
    
    private var bottomSection: some View {
        VStack(spacing: AppSpacing.md) {
            PrimaryButton(
                title: viewModel.authMode == .login ? "Iniciar Sesión" : "Crear Cuenta"
            ) {
                Task {
                    if viewModel.authMode == .login {
                        await viewModel.login()
                    } else {
                        await viewModel.signUp()
                    }
                }
            }
            .disabled(viewModel.isLoading || (viewModel.authMode == .login ? !viewModel.isLoginValid : !viewModel.isSignUpValid))
            .opacity(viewModel.isLoading ? 0.6 : 1.0)
            
            toggleAuthModeButton
        }
    }
    
    private var toggleAuthModeButton: some View {
        Button(action: {
            viewModel.toggleAuthMode()
        }) {
            HStack(spacing: AppSpacing.xs) {
                Text(viewModel.authMode == .login ? "¿No tienes cuenta?" : "¿Ya tienes cuenta?")
                    .font(AppFonts.body)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.authMode == .login ? "Regístrate" : "Inicia Sesión")
                    .font(AppFonts.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
            }
        }
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    AuthView(router: AppRouter())
}

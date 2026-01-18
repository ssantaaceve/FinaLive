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
    @ObservedObject var router: AppRouter
    
    @StateObject private var viewModel: AuthViewModel
    
    init(router: AppRouter) {
        self.router = router
        _viewModel = StateObject(wrappedValue: AuthViewModel(router: router))
    }
    
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
        .background(AppBackground())
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                // Separador sutil
                Rectangle()
                    .fill(AppColors.border.opacity(0.2))
                    .frame(height: 0.5)
                
                bottomSection
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.lg)
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
                .foregroundStyle(AppColors.textPrimary)
            
            Text("Bienvenido a FinaLive")
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textSecondary)
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
                .fill(AppColors.border)
                .frame(height: 1)
            
            Text("o")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            Rectangle()
                .fill(AppColors.border)
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
                .padding(.bottom, AppSpacing.xs)
        }
    }
    
    private var toggleAuthModeButton: some View {
        Button(action: {
            viewModel.toggleAuthMode()
        }) {
            HStack(spacing: AppSpacing.xs) {
                Text(viewModel.authMode == .login ? "¿No tienes cuenta?" : "¿Ya tienes cuenta?")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                
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

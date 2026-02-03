//
//  LoginView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 28/1/2026.
//

import SwiftUI


struct LoginView: View {
    // Inyectamos el ViewModel padre
    @ObservedObject var viewModel: AuthViewModel
    
    // Inyectamos la acción de navegación
    var onLoginSuccess: () -> Void
    
    var body: some View {
        ZStack {
            // Fondo Base Unificado (AppBackground)
            AppBackground()
            
            // Decir adiós al Ellipse manual, AppBackground ya maneja el gradiente
            
            
            VStack(spacing: 0) {
                // 1. Header (Logo Top Leading - Increased Size)
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.primary)
                    
                    Text("FinaLive")
                        .font(.largeTitle.bold())
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg) // More top padding
                
                Spacer()
                
                // 2. Main Content Group (Text + Action) - Centered
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Hero Text
                    Text("Domina tus finanzas, cumple tus metas y desbloquea recompensas exclusivas.")
                        .font(AppFonts.title.bold())
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.8)
                    
                    // Button Group & Inputs
                    VStack(spacing: AppSpacing.md) {
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(AppColors.error)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Campos de Texto
                        VStack(spacing: AppSpacing.sm) {
                            TextField("Correo electrónico", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .padding()
                                .background(AppColors.surfacePrimary.opacity(0.3))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.textSecondary.opacity(0.3), lineWidth: 1)
                                )
                                .foregroundStyle(AppColors.textPrimary)
                            
                            SecureField("Contraseña", text: $viewModel.password)
                                .padding()
                                .background(AppColors.surfacePrimary.opacity(0.3))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.textSecondary.opacity(0.3), lineWidth: 1)
                                )
                                .foregroundStyle(AppColors.textPrimary)
                        }
                        
                        // Botones de Acción
                        HStack(spacing: AppSpacing.md) {
                            Button(action: {
                                Task { await viewModel.signIn() }
                            }) {
                                Text("Entrar")
                                    .font(AppFonts.body.bold())
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppColors.primary)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                Task { await viewModel.signUp() }
                            }) {
                                Text("Registrarse")
                                    .font(AppFonts.body.bold())
                                    .foregroundStyle(AppColors.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppColors.primary.opacity(0.1))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AppColors.primary, lineWidth: 1)
                                    )
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .opacity(viewModel.isLoading ? 0.7 : 1.0)
                        
                        // Terms Text
                        Text("Al continuar aceptas nuestros términos y condiciones.")
                            .font(.caption2)
                            .foregroundStyle(AppColors.textSecondary.opacity(0.6))
                        
                        // Divider
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(AppColors.textSecondary.opacity(0.2))
                            Text("O").font(.caption).foregroundColor(AppColors.textSecondary)
                            Rectangle().frame(height: 1).foregroundColor(AppColors.textSecondary.opacity(0.2))
                        }
                        .padding(.vertical, 5)
                        
                        // Apple Sign In Button (Restored)
                        Button(action: {
                            // TODO: Implementar lógica real con Supabase Auth Apple Provider
                            Task { await viewModel.handleAppleLogin() }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 19))
                                    .offset(y: -1)
                                
                                Text("Sign in with Apple")
                                    .font(.system(size: 19, weight: .medium, design: .default))
                            }
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer()
                
                // Bottom Padding Spacer to prevent content from hitting the very bottom
                Spacer()
                    .frame(height: AppSpacing.xl)
            }
        }
    }
    
    private func executeLogin() {
        Task {
            await viewModel.handleAppleLogin()
            // La navegación la maneja ahora el router dentro del VM o el closure onLoginSuccess
            // Mantenemos onLoginSuccess para compatibilidad con AuthView
            onLoginSuccess() 
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(router: nil), onLoginSuccess: {})
}

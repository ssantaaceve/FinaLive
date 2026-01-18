//
//  LoginView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista de login con email y contraseña
struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            emailField
            passwordField
            
            if let error = viewModel.errorMessage {
                errorMessageView(error)
            }
        }
    }
    
    // MARK: - View Components
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Email")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            TextField("ejemplo@email.com", text: $viewModel.loginEmail)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundStyle(AppColors.textPrimary)
                .tint(AppColors.primary)
                .focused($focusedField, equals: .email)
                .padding(AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.sm)
                        .fill(AppColors.surfacePrimary)
                        .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.sm)
                                .strokeBorder(AppColors.border, lineWidth: 0.5)
                        }
                }
                .accentColor(AppColors.primary)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Contraseña")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            SecureField("Contraseña", text: $viewModel.loginPassword)
                .textContentType(.password)
                .foregroundStyle(AppColors.textPrimary)
                .tint(AppColors.primary)
                .focused($focusedField, equals: .password)
                .padding(AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.sm)
                        .fill(AppColors.surfacePrimary)
                        .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.sm)
                                .strokeBorder(AppColors.border, lineWidth: 0.5)
                        }
                }
                .accentColor(AppColors.primary)
        }
    }
    
    private func errorMessageView(_ message: String) -> some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(AppColors.error)
            Text(message)
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.error)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(router: nil))
        .padding()
}

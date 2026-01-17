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
                .foregroundStyle(.secondary)
            
            TextField("ejemplo@email.com", text: $viewModel.loginEmail)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .padding(AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.sm)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.sm)
                                .strokeBorder(.quaternary, lineWidth: 0.5)
                        }
                }
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Contraseña")
                .font(AppFonts.caption)
                .foregroundStyle(.secondary)
            
            SecureField("Contraseña", text: $viewModel.loginPassword)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .padding(AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.sm)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.sm)
                                .strokeBorder(.quaternary, lineWidth: 0.5)
                        }
                }
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

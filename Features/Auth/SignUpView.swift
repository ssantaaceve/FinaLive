//
//  SignUpView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista de registro con nombre, email, teléfono y contraseña
struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
        case email
        case phone
        case password
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            nameField
            emailField
            phoneField
            passwordField
            
            if let error = viewModel.errorMessage {
                errorMessageView(error)
            }
        }
    }
    
    // MARK: - View Components
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Nombre")
                .font(AppFonts.caption)
                .foregroundStyle(.secondary)
            
            TextField("Nombre completo", text: $viewModel.signUpName)
                .textContentType(.name)
                .autocapitalization(.words)
                .focused($focusedField, equals: .name)
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
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Email")
                .font(AppFonts.caption)
                .foregroundStyle(.secondary)
            
            TextField("ejemplo@email.com", text: $viewModel.signUpEmail)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textInputAutocorrectionDisabled()
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
    
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Teléfono")
                .font(AppFonts.caption)
                .foregroundStyle(.secondary)
            
            TextField("+1 234 567 8900", text: $viewModel.signUpPhone)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)
                .focused($focusedField, equals: .phone)
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
            
            SecureField("Contraseña", text: $viewModel.signUpPassword)
                .textContentType(.newPassword)
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
    SignUpView(viewModel: AuthViewModel())
        .padding()
}

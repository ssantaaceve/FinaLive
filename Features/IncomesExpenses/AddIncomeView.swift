//
//  AddIncomeView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista para registrar un nuevo ingreso
/// Formulario con efecto glass y campos simplificados
struct AddIncomeView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var category: String = ""
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case category
        case amount
        case description
    }
    
    private let incomeCategories = [
        "Salario", "Freelance", "Inversiones", "Ventas",
        "Bonos", "Regalos", "Otro"
    ]
    
    var body: some View {
        ZStack {
            // Fondo gradiente
            AppBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Header visual
                    headerSection
                    
                    // Categoría
                    categoryField
                    
                    // Monto
                    amountField
                    
                    // Fecha
                    dateField
                    
                    // Descripción
                    descriptionField
                    
                    // Botón de acción
                    saveButton
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle("Registrar Ingreso")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {
                    dismiss()
                }
                .foregroundStyle(AppColors.textPrimary)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !category.isEmpty &&
        !amount.isEmpty &&
        Double(amount) != nil &&
        Double(amount)! > 0 &&
        !description.isEmpty
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("Nuevo Ingreso")
                .font(AppFonts.title2)
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.vertical, AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var categoryField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Categoría")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            Picker("Categoría", selection: $category) {
                Text("Selecciona una categoría").tag("")
                    .foregroundStyle(AppColors.textPrimary.opacity(0.5))
                ForEach(incomeCategories, id: \.self) { cat in
                    Text(cat).tag(cat)
                }
            }
            .pickerStyle(.menu)
            .foregroundStyle(AppColors.textPrimary)
            .tint(AppColors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.sm)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.sm)
                    .strokeBorder(AppColors.textPrimary.opacity(0.3), lineWidth: 0.5)
            }
        }
    }
    
    private var amountField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Monto")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            HStack(spacing: AppSpacing.xs) {
                Text("$")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary.opacity(0.7))
                
                TextField("0.00", text: $amount)
                    .font(AppFonts.headline)
                    .keyboardType(.decimalPad)
                    .foregroundStyle(AppColors.textPrimary)
                    .tint(AppColors.textPrimary)
                    .focused($focusedField, equals: .amount)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.sm)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.sm)
                    .strokeBorder(AppColors.textPrimary.opacity(0.3), lineWidth: 0.5)
            }
        }
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Fecha")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .foregroundStyle(AppColors.textPrimary)
                .tint(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, AppSpacing.md)
                .padding(.horizontal, AppSpacing.sm)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.sm)
                        .strokeBorder(AppColors.textPrimary.opacity(0.3), lineWidth: 0.5)
                }
        }
    }
    
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Descripción")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            TextField("Descripción del ingreso", text: $description, axis: .vertical)
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textPrimary)
                .tint(AppColors.textPrimary)
                .focused($focusedField, equals: .description)
                .lineLimit(3...6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, AppSpacing.md)
                .padding(.horizontal, AppSpacing.sm)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.sm)
                        .strokeBorder(AppColors.textPrimary.opacity(0.3), lineWidth: 0.5)
                }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            // TODO: Guardar ingreso
            dismiss()
        }) {
            Text("Guardar Ingreso")
                .font(AppFonts.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.md)
                        .fill(AppColors.success.gradient)
                }
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.5)
        .padding(.top, AppSpacing.md)
    }
}

#Preview {
    NavigationStack {
        AddIncomeView()
    }
}

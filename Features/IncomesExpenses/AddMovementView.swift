//
//  AddMovementView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista para agregar un nuevo movimiento (Ingreso o Gasto)
/// Bottom sheet con efecto glass y formulario simplificado
struct AddMovementView: View {
    @Binding var isPresented: Bool
    
    @State private var movementType: Transaction.TransactionType = .expense
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
    
    private let categories = [
        "Salario", "Freelance", "Inversiones", "Compras",
        "Alimentación", "Transporte", "Servicios", "Entretenimiento", "Otro"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo gradiente
                AppBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // Tipo de movimiento
                        typeSelector
                        
                        // Categoría
                        categoryField
                        
                        // Monto
                        amountField
                        
                        // Fecha
                        dateField
                        
                        // Descripción
                        descriptionField
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Nuevo Movimiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                    .foregroundStyle(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        // TODO: Guardar movimiento
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.5)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
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
    
    private var typeSelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Tipo de Movimiento")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            Picker("Tipo", selection: $movementType) {
                Text("Ingreso").tag(Transaction.TransactionType.income)
                Text("Gasto").tag(Transaction.TransactionType.expense)
            }
            .pickerStyle(.segmented)
            .tint(AppColors.primary)
        }
    }
    
    private var categoryField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Categoría")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            Picker("Categoría", selection: $category) {
                Text("Selecciona una categoría").tag("")
                ForEach(categories, id: \.self) { cat in
                    Text(cat).tag(cat)
                }
            }
            .pickerStyle(.menu)
            .foregroundStyle(AppColors.textPrimary)
            .padding(AppSpacing.sm)
            .background(GlassBackground(cornerRadius: AppSpacing.sm))
        }
    }
    
    private var amountField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Monto")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            HStack {
                Text("$")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textSecondary)
                
                TextField("0.00", text: $amount)
                    .font(AppFonts.headline)
                    .keyboardType(.decimalPad)
                    .foregroundStyle(AppColors.textPrimary)
                    .tint(AppColors.primary)
                    .focused($focusedField, equals: .amount)
            }
            .padding(AppSpacing.sm)
            .background(GlassBackground(cornerRadius: AppSpacing.sm))
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
                .padding(AppSpacing.sm)
                .background(GlassBackground(cornerRadius: AppSpacing.sm))
        }
    }
    
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Descripción")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            TextField("Descripción del movimiento", text: $description, axis: .vertical)
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textPrimary)
                .tint(AppColors.primary)
                .focused($focusedField, equals: .description)
                .lineLimit(3...6)
                .padding(AppSpacing.sm)
                .background(GlassBackground(cornerRadius: AppSpacing.sm))
        }
    }
}

#Preview {
    AddMovementView(isPresented: .constant(true))
}

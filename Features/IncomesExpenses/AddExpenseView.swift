//
//  AddExpenseView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista para registrar un nuevo gasto
/// Formulario con efecto glass y campos simplificados
struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var category: String = ""
    @State private var amount: String = ""
    @State private var rawAmount: String = "" // Almacena solo números
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker: Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case category
        case amount
        case description
    }
    
    private let expenseCategories = [
        "Compras", "Alimentación", "Transporte", "Servicios",
        "Entretenimiento", "Salud", "Educación", "Otro"
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
        .sheet(isPresented: $showDatePicker) {
            datePickerSheet
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !category.isEmpty &&
        !rawAmount.isEmpty &&
        getNumericValue(from: rawAmount) > 0 &&
        !description.isEmpty
    }
    
    // MARK: - Helper Methods
    
    /// Convierte el rawAmount (solo números) a valor numérico en formato colombiano
    private func getNumericValue(from rawValue: String) -> Double {
        guard !rawValue.isEmpty else { return 0 }
        // Los últimos 2 dígitos son decimales
        let totalValue = Double(rawValue) ?? 0
        return totalValue / 100.0
    }
    
    /// Formatea el número en formato colombiano (1.000.000,50)
    /// Los últimos 2 dígitos siempre se tratan como decimales
    private func formatColombianCurrency(_ numbersOnly: String) -> String {
        guard !numbersOnly.isEmpty else { return "" }
        
        // Si solo hay 1 dígito, mostrar como "0,0X"
        if numbersOnly.count == 1 {
            return "0,0\(numbersOnly)"
        }
        
        // Si hay 2 dígitos, mostrar como "0,XX"
        if numbersOnly.count == 2 {
            return "0,\(numbersOnly)"
        }
        
        // Separar parte entera y decimales (últimos 2 dígitos)
        let decimalPart = String(numbersOnly.suffix(2))
        let integerPart = String(numbersOnly.dropLast(2))
        
        // Formatear parte entera con puntos como separadores de miles
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        
        let integerValue = Int(integerPart) ?? 0
        let formattedInteger = formatter.string(from: NSNumber(value: integerValue)) ?? integerPart
        
        // Combinar: parte entera + coma + decimales
        return "\(formattedInteger),\(decimalPart)"
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("Nuevo Gasto")
                .font(AppFonts.title)
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
                ForEach(expenseCategories, id: \.self) { cat in
                    Text(cat).tag(cat)
                }
            }
            .pickerStyle(.menu)
            .foregroundStyle(category.isEmpty ? AppColors.textPrimary.opacity(0.5) : AppColors.textPrimary)
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
                    .foregroundStyle(rawAmount.isEmpty ? AppColors.textPrimary.opacity(0.5) : AppColors.textPrimary)
                
                ZStack(alignment: .leading) {
                    // Placeholder visible cuando está vacío
                    if rawAmount.isEmpty {
                        Text("0,00")
                            .font(AppFonts.headline)
                            .foregroundStyle(AppColors.textPrimary.opacity(0.5))
                    }
                    
                    // Texto formateado visible (se actualiza en tiempo real)
                    if !rawAmount.isEmpty {
                        Text(amount)
                            .font(AppFonts.headline)
                            .foregroundStyle(AppColors.textPrimary)
                            .allowsHitTesting(false) // Permitir que los toques pasen al TextField
                    }
                    
                    // TextField invisible que solo captura números
                    TextField("", text: Binding(
                        get: { rawAmount },
                        set: { newValue in
                            // Filtrar solo números inmediatamente
                            let numbersOnly = newValue.filter { $0.isNumber }
                            
                            // Actualizar rawAmount
                            rawAmount = numbersOnly
                            
                            // Formatear inmediatamente en tiempo real
                            if numbersOnly.isEmpty {
                                amount = ""
                            } else {
                                amount = formatColombianCurrency(numbersOnly)
                            }
                        }
                    ))
                    .font(AppFonts.headline)
                    .keyboardType(.numberPad)
                    .foregroundColor(.clear) // Texto invisible
                    .accentColor(AppColors.textPrimary) // Cursor visible
                    .focused($focusedField, equals: .amount)
                    .onChange(of: rawAmount) { oldValue, newValue in
                        // Asegurar que el formateo se actualice cuando cambia rawAmount
                        if !newValue.isEmpty {
                            let formatted = formatColombianCurrency(newValue)
                            if amount != formatted {
                                amount = formatted
                            }
                        } else if !amount.isEmpty {
                            amount = ""
                        }
                    }
                }
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

            HStack {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.textPrimary.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.sm)
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.sm)
                    .strokeBorder(
                        AppColors.textPrimary.opacity(0.3),
                        lineWidth: 0.5
                    )
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showDatePicker = true
            }
        }
    }
    
    private var datePickerSheet: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(AppColors.primary)
                .colorScheme(.dark)
            }
            .padding(AppSpacing.md)
            .background(AppBackground())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        showDatePicker = false
                    }
                    .foregroundStyle(AppColors.primary)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Descripción")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            ZStack(alignment: .topLeading) {
                // Placeholder visible cuando está vacío
                if description.isEmpty {
                    Text("Descripción del gasto")
                        .font(AppFonts.body)
                        .foregroundStyle(AppColors.textPrimary.opacity(0.5))
                        .padding(.vertical, AppSpacing.md)
                        .padding(.horizontal, AppSpacing.sm)
                }
                
                TextField("", text: $description, axis: .vertical)
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textPrimary)
                    .tint(AppColors.textPrimary)
                    .focused($focusedField, equals: .description)
                    .lineLimit(3...6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, AppSpacing.md)
                    .padding(.horizontal, AppSpacing.sm)
            }
            .background {
                RoundedRectangle(cornerRadius: AppSpacing.sm)
                    .strokeBorder(AppColors.textPrimary.opacity(0.3), lineWidth: 0.5)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            // TODO: Guardar gasto
            dismiss()
        }) {
            Text("Guardar Gasto")
                .font(AppFonts.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background {
                    RoundedRectangle(cornerRadius: AppSpacing.md)
                        .fill(AppColors.error.gradient)
                }
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.5)
        .padding(.top, AppSpacing.md)
    }
}

#Preview {
    NavigationStack {
        AddExpenseView()
    }
}

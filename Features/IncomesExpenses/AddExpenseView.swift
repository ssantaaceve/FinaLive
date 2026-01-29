//
//  AddExpenseView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista para registrar un nuevo gasto
/// Implementación "Liquid Glass Expandable"
struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var category: String = ""
    @State private var amount: String = ""
    @State private var rawAmount: String = "" // Almacena solo números
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    
    // UI States for Expandable Modules
    @State private var isCategoryExpanded: Bool = false
    @State private var isDateExpanded: Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case category
        case amount
        case description
    }
    
    private let expenseCategories = [
        "Vivienda y Servicios",
        "Alimentación",
        "Transporte",
        "Compras Personales",
        "Salud y Bienestar",
        "Ocio y Vida Social",
        "Educación y Desarrollo",
        "Finanzas y Obligaciones",
        "Otro"
    ]
    
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    categoryModule
                    amountModule
                    dateModule
                    descriptionModule
                    saveButton
                        .padding(.top, AppSpacing.md)
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
        VStack(spacing: 4) {
            Text("Nuevo Gasto")
                .font(AppFonts.title)
                .foregroundStyle(AppColors.textPrimary)
            
            Text("Registra tus movimientos")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
    }
    
    // MARK: - Expandable Modules
    
    private var categoryModule: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categoría")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                // Header (Always Visible)
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isCategoryExpanded.toggle()
                        // Close other expandables
                        if isCategoryExpanded { isDateExpanded = false }
                    }
                }) {
                    HStack {
                        if category.isEmpty {
                            Text("Selecciona una categoría")
                                .foregroundStyle(AppColors.textPrimary.opacity(0.5))
                        } else {
                            Text(category)
                                .fontWeight(.medium)
                                .foregroundStyle(AppColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundStyle(AppColors.textSecondary)
                            .rotationEffect(.degrees(isCategoryExpanded ? 180 : 0))
                    }
                    .padding(16)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                // Expanded Content
                if isCategoryExpanded {
                    Divider()
                        .background(AppColors.textPrimary.opacity(0.1))
                        .padding(.horizontal, 16)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                        ForEach(expenseCategories, id: \.self) { cat in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    category = cat
                                    isCategoryExpanded = false
                                }
                            }) {
                                Text(cat)
                                    .font(.caption)
                                    .fontWeight(category == cat ? .semibold : .regular)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        if category == cat {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.primary.opacity(0.15))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                                                )
                                        } else {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.black.opacity(0.2))
                                        }
                                    }
                                    .foregroundStyle(category == cat ? AppColors.primary : AppColors.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(GlassModuleContainer())
        }
    }
    
    private var dateModule: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fecha")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                // Header
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isDateExpanded.toggle()
                        if isDateExpanded { isCategoryExpanded = false }
                    }
                }) {
                    HStack {
                        Text(selectedDate.formatted(date: .long, time: .omitted))
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundStyle(isDateExpanded ? AppColors.primary : AppColors.textSecondary)
                    }
                    .padding(16)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                // Inline Date Picker
                if isDateExpanded {
                    Divider()
                        .background(AppColors.textPrimary.opacity(0.1))
                        .padding(.horizontal, 16)
                    
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(AppColors.primary)
                    .environment(\.colorScheme, .dark) // Force white text
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(GlassModuleContainer())
        }
    }
    
    private var amountModule: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monto")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.leading, 4)
            
            HStack(spacing: 4) {
                Text("$")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(rawAmount.isEmpty ? AppColors.textPrimary.opacity(0.3) : AppColors.textPrimary)
                
                ZStack(alignment: .leading) {
                    if rawAmount.isEmpty {
                        Text("0,00")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary.opacity(0.3))
                    }
                    
                    if !rawAmount.isEmpty {
                        Text(amount)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    
                    TextField("", text: Binding(
                        get: { rawAmount },
                        set: { newValue in
                            let numbersOnly = newValue.filter { $0.isNumber }
                            rawAmount = numbersOnly
                            if numbersOnly.isEmpty {
                                amount = ""
                            } else {
                                amount = formatColombianCurrency(numbersOnly)
                            }
                        }
                    ))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .keyboardType(.numberPad)
                    .foregroundColor(.clear)
                    .tint(AppColors.primary)
                    .focused($focusedField, equals: .amount)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(GlassModuleContainer())
            .onTapGesture {
                focusedField = .amount
            }
        }
    }
    
    private var descriptionModule: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Descripción")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.leading, 4)
            
            ZStack(alignment: .leading) {
                if description.isEmpty {
                    Text("Ej: Café en Juan Valdez")
                        .foregroundStyle(AppColors.textPrimary.opacity(0.3))
                        .padding(.horizontal, 4)
                }
                
                TextField("", text: $description)
                    .foregroundStyle(AppColors.textPrimary)
                    .tint(AppColors.primary)
                    .focused($focusedField, equals: .description)
                    .submitLabel(.done)
                    .padding(.horizontal, 4)
            }
            .padding(16)
            .background(GlassModuleContainer())
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
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.error, 
                                    AppColors.error.opacity(0.7)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: AppColors.error.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.5)
        .animation(.easeInOut, value: isFormValid)
    }
}

#Preview {
    NavigationStack {
        AddExpenseView()
    }
}

//
//  AddExpenseView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 13/1/2026.
//

import SwiftUI

/// Vista para registrar un nuevo gasto
/// Implementación "Liquid Glass Expandable" con MVVM
struct AddExpenseView: View {
    @StateObject private var viewModel = AddTransactionViewModel()
    @Environment(\.dismiss) var dismiss
    
    // UI States (Local Display Logic Only)
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
        .disabled(viewModel.isLoading)
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
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
                        if isCategoryExpanded { isDateExpanded = false }
                    }
                }) {
                    HStack {
                        if viewModel.category.isEmpty {
                            Text("Selecciona una categoría")
                                .foregroundStyle(AppColors.textPrimary.opacity(0.5))
                        } else {
                            Text(viewModel.category)
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
                                    viewModel.category = cat
                                    isCategoryExpanded = false
                                }
                            }) {
                                Text(cat)
                                    .font(.caption)
                                    .fontWeight(viewModel.category == cat ? .semibold : .regular)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        if viewModel.category == cat {
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
                                    .foregroundStyle(viewModel.category == cat ? AppColors.primary : AppColors.textSecondary)
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
                        Text(viewModel.date.formatted(date: .long, time: .omitted))
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
                        selection: $viewModel.date,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(AppColors.primary)
                    .environment(\.colorScheme, .dark)
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
                    .foregroundStyle(viewModel.rawAmount.isEmpty ? AppColors.textPrimary.opacity(0.3) : AppColors.textPrimary)
                
                ZStack(alignment: .leading) {
                    if viewModel.rawAmount.isEmpty {
                        Text("0,00")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary.opacity(0.3))
                    }
                    
                    if !viewModel.rawAmount.isEmpty {
                        Text(viewModel.amount)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    
                    // TextField Invisible con Binding manual al ViewModel
                    TextField("", text: Binding(
                        get: { viewModel.rawAmount },
                        set: { viewModel.updateAmount($0) }
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
                if viewModel.description.isEmpty {
                    Text("Ej: Café en Juan Valdez")
                        .foregroundStyle(AppColors.textPrimary.opacity(0.3))
                        .padding(.horizontal, 4)
                }
                
                TextField("", text: $viewModel.description)
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
            Task {
                await viewModel.saveTransaction(type: .expense) {
                    dismiss()
                }
            }
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primary.opacity(0.5))
                    }
            } else {
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
        }
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .opacity((viewModel.isFormValid && !viewModel.isLoading) ? 1.0 : 0.5)
        .animation(.easeInOut, value: viewModel.isFormValid)
    }
}

#Preview {
    NavigationStack {
        AddExpenseView()
    }
}

//
//  AddTransactionView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Vista para agregar una nueva transacción
/// Permite al usuario ingresar información de ingresos o gastos
struct AddTransactionView: View {
    @StateObject private var viewModel = AddTransactionViewModel()
    @ObservedObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field {
        case amount
        case description
    }
    
    // Local state for type selection since ViewModel doesn't hold it directly (it's passed to save)
    @State private var selectedType: Transaction.TransactionType = .expense
    
    var body: some View {
        NavigationStack {
            Form {
                transactionTypeSection
                informationSection
                // savingsSection was removed as it's not in the new model yet
            }
            .navigationTitle("Nueva Transacción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            await viewModel.saveTransaction(type: selectedType) {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                    .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
    
    // MARK: - View Components
    
    private var transactionTypeSection: some View {
        Section {
            Picker("Tipo", selection: $selectedType) {
                Text("Ingreso").tag(Transaction.TransactionType.income)
                Text("Gasto").tag(Transaction.TransactionType.expense)
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Tipo de Transacción")
        }
    }
    
    private var informationSection: some View {
        Section {
            HStack {
                Text("$")
                    .foregroundStyle(AppColors.textSecondary)
                // Usamos Binding personalizado para rawAmount
                TextField("0,00", text: Binding(
                    get: { viewModel.rawAmount },
                    set: { viewModel.updateAmount($0) }
                ))
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .amount)
            }
            
            TextField("Categoría", text: $viewModel.category)
            
            TextField("Descripción", text: $viewModel.description, axis: .vertical)
                .lineLimit(3...6)
                .focused($focusedField, equals: .description)
        } header: {
            Text("Información")
        }
    }
}

#Preview {
    AddTransactionView(router: AppRouter())
}

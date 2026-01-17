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
    
    var body: some View {
        NavigationStack {
            Form {
                transactionTypeSection
                informationSection
                savingsSection
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
                        viewModel.saveTransaction()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var transactionTypeSection: some View {
        Section {
            Picker("Tipo", selection: $viewModel.isIncome) {
                Text("Ingreso").tag(true)
                Text("Gasto").tag(false)
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
                    .foregroundStyle(.secondary)
                TextField("0.00", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .amount)
            }
            
            TextField("Descripción", text: $viewModel.description, axis: .vertical)
                .lineLimit(3...6)
                .focused($focusedField, equals: .description)
        } header: {
            Text("Información")
        }
    }
    
    private var savingsSection: some View {
        Section {
            Toggle("Marcar como ahorro", isOn: $viewModel.isSaving)
        }
    }
}

#Preview {
    AddTransactionView(router: AppRouter())
}

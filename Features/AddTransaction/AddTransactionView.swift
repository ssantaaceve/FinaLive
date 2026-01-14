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
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Tipo de Transacción")) {
                    Picker("Tipo", selection: $viewModel.isIncome) {
                        Text("Ingreso").tag(true)
                        Text("Gasto").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Información")) {
                    TextField("Monto", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Descripción", text: $viewModel.description)
                }
                
                Section {
                    Toggle("Es ahorro", isOn: $viewModel.isSaving)
                }
            }
            .navigationTitle("Nueva Transacción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        viewModel.saveTransaction()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    AddTransactionView(router: AppRouter())
}

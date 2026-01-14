//
//  HomeView.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import SwiftUI

/// Vista principal de la aplicación
/// Muestra el resumen financiero y permite navegar a otras secciones
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var router: AppRouter
    @State private var showAddTransaction: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Balance card
                VStack(spacing: 8) {
                    Text("Balance Total")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("$\(viewModel.balance, specifier: "%.2f")")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                Spacer()
                
                // Placeholder para lista de transacciones
                Text("No hay transacciones aún")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("FinaLive")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTransaction = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView(router: router)
            }
        }
    }
}

#Preview {
    HomeView(router: AppRouter())
}

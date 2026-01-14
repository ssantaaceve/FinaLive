//
//  HomeViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation

/// ViewModel para la pantalla principal
/// Maneja la lógica de presentación de datos y acciones del usuario
@MainActor
class HomeViewModel: ObservableObject {
    @Published var balance: Double = 0.0
    @Published var isLoading: Bool = false
    
    init() {
        loadData()
    }
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: balance)) ?? "$0.00"
    }
    
    func loadData() {
        // TODO: Cargar datos de transacciones desde servicio
        isLoading = false
    }
    
    func refreshAsync() async {
        isLoading = true
        // Simular carga asíncrona
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadData()
    }
}

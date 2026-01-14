//
//  HomeViewModel.swift
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 9/1/2026.
//

import Foundation
import SwiftUI

/// ViewModel para la pantalla principal
/// Maneja la lógica de presentación de datos y acciones del usuario
class HomeViewModel: ObservableObject {
    @Published var balance: Double = 0.0
    @Published var isLoading: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        // TODO: Cargar datos de transacciones
        isLoading = false
    }
    
    func refresh() {
        isLoading = true
        loadData()
    }
}

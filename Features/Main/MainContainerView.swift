//
//  MainContainerView.swift
//  FinaLive
//
//  Created by Sergio Andres Santa Acevedo on 29/1/2026.
//

import SwiftUI

/// Vista contenedora principal que gestiona la navegación global
/// Mantiene la barra de navegación inferior persistente entre secciones
struct MainContainerView: View {
    @StateObject private var router = AppRouter()
    @State private var selectedTab: HomeBottomNavigationView.BottomTab = .home
    @State private var navigationPath = NavigationPath()
    
    // Estados para el gesto del botón central
    @State private var isDraggingTransaction: Bool = false
    @State private var dragDirection: HomeBottomNavigationView.DragDirection = .none
    @State private var dragProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Fondo global
            AppBackground()
            
            // Contenido Principal
            Group {
                if selectedTab == .home {
                    HomeView(router: router)
                        .transition(.move(edge: .leading))
                } else if selectedTab == .profile {
                    ProfileView()
                        .transition(.move(edge: .trailing))
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Espacio reservado para la bottom bar
                Color.clear.frame(height: 100)
            }
            
            // Navegación Inferior Flotante (Persistente)
            VStack {
                Spacer()
                
                HomeBottomNavigationView(
                    selectedTab: $selectedTab,
                    onTransactionAction: { action in
                        handleTransactionAction(action)
                    },
                    isDragging: $isDraggingTransaction,
                    dragDirection: $dragDirection,
                    dragProgress: $dragProgress
                )
            }
            .ignoresSafeArea(.keyboard)
            
            // Overlay de efectos globales (Drag)
            if isDraggingTransaction && dragDirection != .none {
                dragOverlayEffect
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        // Manejo de navegación global (modales, etc.)
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .addExpense:
                AddExpenseView()
            case .addIncome:
                AddIncomeView()
            }
        }
    }
    
    // MARK: - Logic
    
    private func handleTransactionAction(_ action: TransactionAction) {
        switch action {
        case .expense:
            router.presentedSheet = .addExpense
        case .income:
            router.presentedSheet = .addIncome
        }
    }
    
    // MARK: - Visual Effects
    
    private var dragOverlayEffect: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let buttonY = screenHeight - 50 // Posición aproximada del botón central
            let buttonCenter = UnitPoint(x: 0.5, y: buttonY / screenHeight)
            
            // Radio dinámico
            let maxRadius = max(screenWidth, screenHeight) * 1.5
            let currentRadius = 50 + (maxRadius - 50) * dragProgress
            
            ZStack {
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: overlayColor.opacity(0.7 * dragProgress), location: 0),
                        .init(color: overlayColor.opacity(0.0), location: 1)
                    ]),
                    center: buttonCenter,
                    startRadius: 40,
                    endRadius: currentRadius
                )
                .blendMode(.screen)
            }
        }
    }
    
    private var overlayColor: Color {
        switch dragDirection {
        case .up: return AppColors.error
        case .down: return AppColors.success
        case .none: return .clear
        }
    }
}



#Preview {
    MainContainerView()
}

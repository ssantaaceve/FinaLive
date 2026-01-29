//
//  NotificationsViewModel.swift
//  FinaLive
//
//  Created by FinaLive AI on 28/1/2026.
//

import Foundation
import SwiftUI

// MARK: - Models

enum NotificationType {
    case reward
    case alert
    case info
    
    var iconName: String {
        switch self {
        case .reward: return "trophy.fill"
        case .alert: return "exclamationmark.triangle.fill"
        case .info: return "bell.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .reward: return AppColors.warning // Gold/Yellow ish
        case .alert: return AppColors.error
        case .info: return AppColors.primary
        }
    }
}

struct NotificationModel: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let message: String
    let date: Date
    var isRead: Bool
}

struct NotificationSection: Identifiable {
    let id = UUID()
    let title: String
    var items: [NotificationModel]
}

// MARK: - ViewModel

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var sections: [NotificationSection] = []
    @Published var isLoading: Bool = false
    
    var unreadCount: Int {
        sections.flatMap { $0.items }.filter { !$0.isRead }.count
    }
    
    var hasNotifications: Bool {
        !sections.isEmpty
    }
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        isLoading = true
        
        // Simular carga
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.generateMockData()
            self?.isLoading = false
        }
    }
    
    func markAllAsRead() {
        for i in 0..<sections.count {
            for j in 0..<sections[i].items.count {
                sections[i].items[j].isRead = true
            }
        }
    }
    
    func markAsRead(id: UUID) {
        for i in 0..<sections.count {
            if let index = sections[i].items.firstIndex(where: { $0.id == id }) {
                sections[i].items[index].isRead = true
                return
            }
        }
    }
    
    private func generateMockData() {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let todayItems = [
            NotificationModel(
                type: .reward,
                title: "¡Ganaste un Bono!",
                message: "Has registrado tus gastos por 3 días seguidos. ¡Sigue así para ganar más!",
                date: today,
                isRead: false
            ),
            NotificationModel(
                type: .alert,
                title: "Alerta de Presupuesto",
                message: "Te estás acercando al límite de tu presupuesto en Comida (85%).",
                date: today,
                isRead: false
            )
        ]
        
        let yesterdayItems = [
            NotificationModel(
                type: .info,
                title: "Bienvenido a FinaLive",
                message: "Empieza a organizar tus finanzas hoy mismo. Configura tus metas.",
                date: yesterday,
                isRead: true
            )
        ]
        
        self.sections = [
            NotificationSection(title: "Hoy", items: todayItems),
            NotificationSection(title: "Ayer", items: yesterdayItems)
        ]
    }
}

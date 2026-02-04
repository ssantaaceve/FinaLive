//
//  NotificationManager.swift
//  FinaLive
//
//  Created by FinaLive Architect on 04/02/2026.
//

import Foundation
import UserNotifications

/// Gestor Singleton para notificaciones locales
/// Se encarga de solicitar permisos y programar recordatorios
class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    private let pendingID = "daily_expense_reminder"
    
    private override init() {
        super.init()
        // Opcional: configurar delegado si necesitamos manejar acciones al recibirla
    }
    
    // MARK: - Authorization
    
    /// Solicita permiso al usuario para enviar notificaciones
    /// - Parameter completion: Closure opcional con el resultado (bool) y error
    func requestAuthorization(completion: ((Bool, Error?) -> Void)? = nil) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Error solicitando permisos de notificación: \(error)")
            } else {
                print("📣 Permisos de notificación otorgados: \(granted)")
            }
            
            // Guardar flag de que ya se solicitó para no molestar innecesariamente
            // (Aunque Apple maneja esto, es bueno tener control interno si queremos)
            if granted {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "hasNotificationsEnabled")
                }
            }
            
            completion?(granted, error)
        }
    }
    
    /// Verifica el estado actual de los permisos
    func checkPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    // MARK: - Scheduling
    
    /// Programa el recordatorio diario a las 8:00 PM
    func scheduleDailyReminder() {
        // 1. Limpiar anterior para evitar duplicados / inconsistencias
        cancelDailyReminder()
        
        // 2. Crear Contenido
        let content = UNMutableNotificationContent()
        content.title = "Hora de registrar"
        content.body = "No olvides anotar tus gastos del día 📝"
        content.sound = .default
        
        // 3. Crear Trigger (8:00 PM Diario)
        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 8:00 PM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 4. Crear Request
        let request = UNNotificationRequest(identifier: pendingID, content: content, trigger: trigger)
        
        // 5. Agendar
        center.add(request) { error in
            if let error = error {
                print("❌ Error agendando notificación diaria: \(error)")
            } else {
                print("✅ Recordatorio diario programado para las 20:00")
            }
        }
    }
    
    /// Cancela el recordatorio diario pendiente
    func cancelDailyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [pendingID])
        print("🗑️ Recordatorio diario eliminado")
    }
    

}

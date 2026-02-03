//
//  Notification+Ext.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import Foundation

extension Notification.Name {
    /// Notificación enviada cuando se completa con éxito una operación de transacción (crear, editar, eliminar).
    static let didUpdateTransactions = Notification.Name("didUpdateTransactions")
}

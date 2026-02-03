//
//  CategoryDistributionItem.swift
//  FinaLive
//
//  Created by FinaLive Architect on 02/02/2026.
//

import SwiftUI

struct CategoryDistributionItem: Identifiable {
    let id = UUID()
    let name: String
    let amount: Decimal
    let icon: String // SF Symbol
    let color: Color
}

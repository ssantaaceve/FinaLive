//
//  AllTransactionsView.swift
//  FinaLive
//
//  Created by FinaLive Architect on 03/02/2026.
//

import SwiftUI

struct AllTransactionsView: View {
    @StateObject private var viewModel = AllTransactionsViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Estado para detectar si el usuario está buscando o filtrando
    private var isFiltering: Bool {
        !viewModel.searchText.isEmpty || viewModel.selectedFilter != .all
    }
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                // 1. Header Personalizado (Liquid Search & Filters)
                headerView
                    .padding(.bottom, 8)
                    // Eliminamos el fondo sólido para que se vea el gradient
                    .labelsHidden()

                if viewModel.isLoading && viewModel.transactions.isEmpty {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                } else if viewModel.filteredTransactions.isEmpty {
                    emptyStateView
                } else {
                    // 3. Lista Agrupada
                    groupedList
                }
            }
        }
        .navigationBarHidden(true) // Ocultamos nav nativa para usar la custom
        .task {
            await viewModel.loadTransactions()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Components
    
    private var headerView: some View {
        VStack(spacing: 20) {
            // 1. Top Bar: Back Button & Large Title
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(8)
                        .background(AppColors.surfacePrimary.opacity(0.5)) // Fondo sutil
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .overlay(
                // Título centrado o alineado? El request pide "alineado a la izquierda arriba",
                // pero con back button suele ser Título abajo o inline.
                // Vamos a poner un Título Grande abajo del back button para jerarquía iOS clásica.
                EmptyView()
            )
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Título Grande
            HStack {
                Text("Historial")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // 2. Buscador "Glass" Personalizado
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.textSecondary)
                
                ZStack(alignment: .leading) {
                    if viewModel.searchText.isEmpty {
                        Text("Buscar movimientos...")
                            .font(AppFonts.body)
                            .foregroundStyle(Color.white) // Placeholder blanco solicitado
                    }
                    TextField("", text: $viewModel.searchText)
                        .font(AppFonts.body)
                        .foregroundStyle(AppColors.textPrimary)
                        .tint(AppColors.primary)
                }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            .frame(height: 48) // Altura fija 48pt
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12) // Radio 12
                    .fill(Color(hex: "1C1C1E")) // Gris casi negro específico
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1) // Borde fino
                    )
            )
            .padding(.horizontal, 16)
            
            // 3. Filtros Limpios
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AllTransactionsViewModel.TransactionTypeFilter.allCases) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            isSelected: viewModel.selectedFilter == filter,
                            onTap: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.selectedFilter = filter
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 12)
    }
    
    private var groupedList: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(viewModel.groupedTransactions, id: \.key) { date, transactions in
                    Section(header: sectionHeader(for: date)) {
                        VStack(spacing: 12) {
                            ForEach(transactions) { transaction in
                                SwipeableRow(content: {
                                    TransactionRowView(transaction: transaction)
                                        .background(AppColors.surfacePrimary) // Fondo sólido
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                        )
                                }, onDelete: {
                                    viewModel.deleteImmediately(transaction)
                                })
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 120) // Padding solicitado
        }
        .scrollContentBackground(.hidden)
    }
    
    private func sectionHeader(for date: Date) -> some View {
        HStack {
            Text(formatHeaderDate(date))
                .font(AppFonts.caption)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textSecondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        // Fondo negro con opacidad para efecto sticky limpio, sin gris feo
        .background(Color.black.opacity(0.9))
    }
    
    // Formateador de Fecha Inteligente
    private func formatHeaderDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Hoy" }
        if calendar.isDateInYesterday(date) { return "Ayer" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM" // Ej: Lunes 25 Ene
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Icono con efecto glow sutil
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 48))
                    .foregroundStyle(AppColors.textSecondary.opacity(0.6))
            }
            
            VStack(spacing: 8) {
                Text(viewModel.searchText.isEmpty ? "No hay movimientos" : "Sin resultados")
                    .font(AppFonts.title3)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(viewModel.searchText.isEmpty ? "Tus transacciones aparecerán aquí." : "Prueba con otro término de búsqueda.")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(32)
         // Aseguramos padding inferior también aquí
        .padding(.bottom, 140)
    }
}

// MARK: - Subcomponents

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(AppFonts.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            Capsule()
                                .fill(AppColors.primary.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(AppColors.primary.opacity(0.5), lineWidth: 1)
                                )
                                // Efecto Neon Sutil
                                .shadow(color: AppColors.primary.opacity(0.4), radius: 6, x: 0, y: 0)
                        } else {
                            Capsule()
                                .fill(AppColors.surfacePrimary.opacity(0.1))
                                .strokeBorder(AppColors.border.opacity(0.1), lineWidth: 1)
                        }
                    }
                )
                .foregroundStyle(isSelected ? AppColors.primary : AppColors.textSecondary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        AllTransactionsView()
    }
}

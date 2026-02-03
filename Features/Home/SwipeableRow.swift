//
//  SwipeableRow.swift
//  FinaLive
//
//  Created by FinaLive Architect on 03/02/2026.
//

import SwiftUI

/// Wrapper reutilizable para implementar "Swipe to Delete" personalizado
/// Diseñado para integrarse con el sistema "Liquid Glass" sin romper el estilo
struct SwipeableRow<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    
    // Configuración del gesto
    private let revealThreshold: CGFloat = -70 // Un poco más profundo para el "hook"
    private let deleteButtonWidth: CGFloat = 85 // Más ancho para el efecto de "emergencia"
    
    // Estados
    @State private var offset: CGFloat = 0
    @State private var isRevealed: Bool = false
    @State private var isDeleting: Bool = false // Para la animación de colapso
    @State private var hasFeedbackOccurred: Bool = false // Para haptic único al cruzar umbral
    
    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Capa de Fondo (Reveal Action)
            GeometryReader { proxy in
                ZStack(alignment: .trailing) {
                    // 1. Fondo Color Sutil ("Organic Reveal")
                    // Se revela a medida que la fila se desliza
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "8B0000").opacity(0.8), // Rojo oscuro/sangre
                                    Color(hex: "500000").opacity(0.9)  // Casi negro
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    // Hacemos que el fondo solo ocupe el espacio necesario o todo el ancho si queremos
                    // Para "que vaya saliendo", un Rectangle simple detrás funciona perfecto al mover la capa superior.
                    
                    // 2. Icono de Basura
                    HStack(spacing: 0) {
                        Spacer()
                        ZStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(hex: "FFCDD2"))
                                .scaleEffect(scaleForOffset(offset))
                                .opacity(opacityForOffset(offset))
                                .offset(x: iconOffsetForOffset(offset))
                        }
                        .frame(width: 50, height: 60) // Área táctil específica para el icono
                        .contentShape(Rectangle())
                        .onTapGesture {
                            triggerDelete()
                        }
                        // Padding derecho dinámico para ajustar el centrado visual respecto al borde
                        .padding(.trailing, 18) 
                    }
                    .frame(width: abs(revealThreshold) + 40) // Asegura que cubra el área revelada mas un margen
                    .contentShape(Rectangle())
                    .onTapGesture {
                        triggerDelete()
                    }
                }
                .frame(maxHeight: .infinity)
            }
            // Solo visible si estamos deslizando (performance)
            .opacity(offset < -1 ? 1 : 0)
            
            // Capa Superior (Contenido)
            content
                .contentShape(Rectangle()) // Asegura que el área de toque se mueva con el offset
                .background(AppColors.backgroundPrimary.opacity(0.001))
                .offset(x: offset)
                .highPriorityGesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onChanged { gesture in
                            handleDragChanged(gesture)
                        }
                        .onEnded { gesture in
                            handleDragEnded(gesture)
                        }
                )
                // Física de resorte personalizada
                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0), value: offset)
        }
        // Animación de colapso vertical al borrar
        .frame(height: isDeleting ? 0 : nil)
        .opacity(isDeleting ? 0 : 1)
        .clipped() // Importante para el recorte durante el colapso
    }
    
    // MARK: - Dynamic Calculations
    
    // Calcula la escala del icono basada en qué tanto se ha deslizado (0.5 -> 1.2 -> 1.0)
    private func scaleForOffset(_ x: CGFloat) -> CGFloat {
        let progress = min(abs(x) / abs(revealThreshold), 1.5)
        if x >= 0 { return 0.5 }
        return 0.5 + (0.7 * progress) // Crece dinámicamente
    }
    
    // Rota el icono suavemente mientras aparece (-15deg -> 0deg)
    private func rotationForOffset(_ x: CGFloat) -> Double {
        let progress = min(abs(x) / abs(revealThreshold), 1.0)
        if x >= 0 { return -15 }
        return -15 + (15 * progress)
    }
    
    // Fade in suave
    private func opacityForOffset(_ x: CGFloat) -> Double {
        let progress = min(abs(x) / (abs(revealThreshold) * 0.5), 1.0)
        if x >= 0 { return 0 }
        return progress
    }
    
    // Movimiento sutil extra tipo parallax para el icono
    private func iconOffsetForOffset(_ x: CGFloat) -> CGFloat {
        if x >= 0 { return 50 } // Fuera de vista
        let progress = min(abs(x) / abs(revealThreshold), 1.0)
        return 20 * (1 - progress) // Se mueve de derecha a su sitio (0)
    }
    
    // MARK: - Logic
    
    private func handleDragChanged(_ gesture: DragGesture.Value) {
        let translation = gesture.translation.width
        
        if translation < 0 {
            // Hacia la izquierda (Revelar)
            // Resistencia elástica progresiva después del umbral
            if translation < revealThreshold {
                let excess = translation - revealThreshold
                offset = revealThreshold + (excess * 0.2) // Alta resistencia
                
                // Haptic al cruzar el umbral (solo una vez)
                if !hasFeedbackOccurred {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    hasFeedbackOccurred = true
                }
            } else {
                offset = translation
                hasFeedbackOccurred = false
            }
        } else {
            // Hacia la derecha (Cerrar)
            if isRevealed {
                offset = revealThreshold + translation
                if offset > 0 { offset = 0 }
            } else {
                offset = translation * 0.1 // Casi inamovible a la derecha
            }
        }
    }
    
    private func handleDragEnded(_ gesture: DragGesture.Value) {
        let translation = gesture.translation.width
        let velocity = gesture.predictedEndTranslation.width
        
        // Lógica de "Snap"
        // Si arrastró suficiente O hizo un "flick" rápido a la izquierda
        if (translation < revealThreshold * 0.6) || (velocity < -100 && translation < 0) {
            reveal()
        } else {
            reset()
        }
        
        hasFeedbackOccurred = false
    }
    
    private func reveal() {
        if !isRevealed {
            let generator = UIImpactFeedbackGenerator(style: .medium) // Feedback más sólido al enganchar
            generator.promptOccurred() // O impactOccurred
        }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
            offset = revealThreshold * 1.05 // Un pelín más para dar aire
        }
        isRevealed = true
    }
    
    private func reset() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            offset = 0
        }
        isRevealed = false
    }
    
    private func triggerDelete() {
        // Haptic fuerte de confirmación
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // 1. Animación de salida lateral (rápida)
        withAnimation(.easeOut(duration: 0.2)) {
            offset = -UIScreen.main.bounds.width
        }
        
        // 2. Colapso vertical (ligeramente retrasado para que se vea el slide primero)
        withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
            isDeleting = true
        }
        
        // 3. Ejecutar acción real
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            onDelete()
        }
    }
}
 
extension UIImpactFeedbackGenerator {
    /// Helper para feedback rápido de "enganche"
    func promptOccurred() {
        self.impactOccurred(intensity: 0.7)
    }
}

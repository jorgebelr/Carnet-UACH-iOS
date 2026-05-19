//
//  StoryView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct StoryView: View {
    let evento: Evento
    @Binding var isPresented: Bool // Esta variable permite que la historia se cierre sola
    @EnvironmentObject var viewModel: EventViewModel

    // Índice actual dentro de las historias (próximos eventos)
    @State private var currentIndex: Int = 0

    // Acceso rápido a la lista de historias
    private var stories: [Evento] { viewModel.upcomingStories }

    // Evento actual mostrado
    private var currentEvent: Evento {
        guard stories.indices.contains(currentIndex) else { return evento }
        return stories[currentIndex]
    }
    
    var body: some View {
        ZStack {
            // 1. FONDO: Efecto difuminado (HCI: Estética y Enfoque)
            // Usamos el color de la categoría con un degradado para que se vea elegante
            LinearGradient(
                colors: [currentEvent.categoria.color.opacity(0.8), .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 2. BARRA DE PROGRESO (Simulada para el look de Instagram)
                HStack(spacing: 4) {
                    Capsule()
                        .fill(Color.white)
                        .frame(height: 3)
                }
                .padding(.top, 20)
                
                // Botón de cerrar (X)
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
                // 3. INFORMACIÓN CENTRAL
                VStack(spacing: 15) {
                    Text(currentEvent.categoria.nombre.uppercased())
                        .font(.caption.bold())
                        .kerning(2) // CORRECCIÓN: Antes era letterSpacing
                        .padding(.vertical, 4) // Ahora Xcode sí entenderá esto
                        .padding(.horizontal, 12)
                        .background(currentEvent.categoria.color)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    
                    Text(currentEvent.nombre)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(currentEvent.descripcion)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // 4. BOTÓN DE ACCIÓN RÁPIDA (Registro Fácil)
                Button(action: {
                    viewModel.addToWallet(currentEvent)
                    isPresented = false
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Agregar a mi Agenda")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal)
            
            // Zonas de toque izquierda/derecha para navegar historias
            HStack(spacing: 0) {
                // Izquierda: anterior
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { goToPrevious() }
                // Derecha: siguiente
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { goToNext() }
            }
        }
        // GESTO: Deslizar hacia abajo para cerrar (HCI: Control del usuario)
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 100 {
                    isPresented = false
                }
            }
        )
        .onAppear { initializeIndex() }
    }
    
    private func initializeIndex() {
        if let idx = stories.firstIndex(where: { $0.id == evento.id }) {
            currentIndex = idx
        } else {
            currentIndex = 0
        }
    }

    private func goToNext() {
        let next = currentIndex + 1
        if next < stories.count {
            currentIndex = next
        } else {
            // No hay más historias: cerrar
            isPresented = false
        }
    }

    private func goToPrevious() {
        let prev = currentIndex - 1
        if prev >= 0 {
            currentIndex = prev
        } else {
            // No hay anterior: cerrar
            isPresented = false
        }
    }
}

// Preview para que lo veas en el Canvas
#Preview {
    StoryView(evento: Evento(
        nombre: "Torneo Inter-UACH",
        descripcion: "Demuestra tu talento en la cancha. ¡Inscríbete ya!",
        fecha: .now,
        lugar: "Gimnasio UACH",
        categoria: .deportivo,
        esCupoLimitado: true,
        cupoMaximo: 20,
        cupoActual: 5
    ), isPresented: .constant(true))
    .environmentObject(EventViewModel())
}

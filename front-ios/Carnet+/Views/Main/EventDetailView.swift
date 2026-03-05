//
//  EventDetailView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct EventDetailView: View {
    let evento: Evento
    @EnvironmentObject var viewModel: EventViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 1. Cabecera con Imagen y Categoría
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(evento.categoria.color.opacity(0.3))
                        .frame(height: 200)
                    
                    Text(evento.categoria.nombre)
                        .font(.caption.bold())
                        .padding(8)
                        .background(evento.categoria.color)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    // Título y Lugar
                    Text(evento.nombre)
                        .font(.largeTitle.bold())
                    
                    Label(evento.lugar, systemImage: "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                    
                    Label(evento.fecha.formatted(date: .long, time: .shortened), systemImage: "calendar")
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Descripción para reducir carga cognitiva [cite: 274, 280]
                    Text("Acerca del evento")
                        .font(.headline)
                    Text(evento.descripcion)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 2. Lógica Condicional de Registro [cite: 287, 291]
                VStack(spacing: 15) {
                    if evento.esCupoLimitado {
                        HStack {
                            Text("Cupos disponibles:")
                            Spacer()
                            Text("\(evento.cupoMaximo! - evento.cupoActual)")
                                .bold()
                                .foregroundColor(evento.hayCupo ? .primary : .red)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Botón de Solicitar Cortesía
                        Button(action: {
                            viewModel.registerToEvent(eventID: evento.id)
                        }) {
                            Text(evento.hayCupo ? "Solicitar Cortesía" : "Evento Saturado")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(evento.hayCupo ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(!evento.hayCupo) // Prevención de errores
                    }
                    
                    // Botón de Guardar (Siempre presente)
                    Button(action: { /* Lógica para guardar */ }) {
                        Label(evento.estaGuardado ? "Guardado" : "Guardar Evento",
                              systemImage: evento.estaGuardado ? "bookmark.fill" : "bookmark")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        EventDetailView(evento: Evento(
            nombre: "Ping Pong Ingeniería",
            descripcion: "Torneo relámpago para todos los niveles. ¡Ven y participa!",
            fecha: .now,
            lugar: "Gimnasio",
            categoria: .deportivo,
            esCupoLimitado: true,
            cupoMaximo: 10,
            cupoActual: 5
        ))
        .environmentObject(EventViewModel())
    }
}

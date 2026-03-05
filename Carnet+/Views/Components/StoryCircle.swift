//
//  StoryCircle.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct StoryCircle: View {
    let evento: Evento
    
    var body: some View {
        VStack {
            ZStack {
                // El borde con el color de la categoría (Pilar 1: Visualización)
                Circle()
                    .stroke(evento.categoria.color)
                    .frame(width: 75, height: 75)
                
                // Imagen o inicial del evento
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 65, height: 65)
                    .overlay(
                        Text(evento.nombre.prefix(1)) // Inicial como placeholder
                            .font(.title2.bold())
                            .foregroundColor(evento.categoria.color)
                    )
            }
            
            Text(evento.nombre)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 80)
        }
    }
}

#Preview {
    StoryCircle(evento: Evento(nombre: "Ping Pong", descripcion: "", fecha: .now, lugar: "Gimnasio", categoria: .deportivo, esCupoLimitado: true))
        .padding()
}

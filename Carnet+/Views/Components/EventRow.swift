//
//  EventRow.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct EventRow: View {
    let evento: Evento
    
    var body: some View {
        HStack(spacing: 15) {
            // Barra lateral de color (HCI: Identificación rápida)
            Capsule()
                .fill(evento.categoria.color)
                .frame(width: 5, height: 45)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(evento.nombre)
                    .font(.headline)
                
                Text(evento.lugar)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Lógica de cupos (HCI: Visibilidad del estado del sistema) [cite: 288]
            if evento.esCupoLimitado {
                VStack(alignment: .trailing) {
                    Text("\(evento.cupoMaximo! - evento.cupoActual)")
                        .font(.callout)
                        .bold()
                        .foregroundColor(evento.hayCupo ? .primary : .red)
                    Text("lugares")
                        .font(.system(size: 10))
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// Preview para el Canvas
#Preview {
    VStack {
        EventRow(evento: Evento(nombre: "Taller de Swift", descripcion: "", fecha: .now, lugar: "Lab 2", categoria: .artistico, esCupoLimitado: true, cupoMaximo: 20, cupoActual: 5))
        EventRow(evento: Evento(nombre: "Concierto UACH", descripcion: "", fecha: .now, lugar: "Paraninfo", categoria: .artistico, esCupoLimitado: false))
    }
    .padding()
}

//
//  TicketDetailView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 08/03/26.
//

import SwiftUI

struct TicketDetailView: View {
    let evento: Evento
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TicketCard(evento: evento)
                
                Text("Muestra este código en la entrada del evento para validar tu asistencia al carnet.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top)
        }
        .navigationTitle("Detalle de Boleto")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// Asegúrate de que el #Preview al final del archivo esté así:
#Preview {
    NavigationStack {
        TicketDetailView(evento: Evento(
            nombre: "Concierto Sinfónica",
            descripcion: "Música clásica en el Paraninfo.",
            fecha: .now,
            lugar: "Paraninfo UACH",
            categoria: .artistico,
            esCupoLimitado: false
        ))
    }
}

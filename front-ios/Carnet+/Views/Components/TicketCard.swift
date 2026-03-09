//
//  TicketCard.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 08/03/26.
//

import SwiftUI

struct TicketCard: View {
    let evento: Evento
    
    var body: some View {
        VStack(spacing: 0) {
            // Parte Superior: Información del Evento
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(evento.categoria.nombre.uppercased())
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(evento.categoria.color.opacity(0.2))
                        .foregroundColor(evento.categoria.color)
                        .cornerRadius(4)
                    Spacer()
                }
                
                Text(evento.nombre)
                    .font(.title3.bold())
                
                Label(evento.lugar, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Divisor con muescas (Efecto Ticket)
            TicketSeparator()
                .fill(Color(.systemGray6))
                .frame(height: 20)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 1)
                )
            
            // Parte Inferior: Código QR Real
            VStack {
                Image(uiImage: QRCodeGenerator().generateQRCode(from: evento.id.uuidString))
                    .resizable()
                    .interpolation(.none) // HCI: Mantiene el QR nítido para escaneo rápido
                    .frame(width: 140, height: 140)
                    .padding()
                
                Text("ID: \(evento.id.uuidString.prefix(8))")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
        }
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding()
    }
}

/// Forma que genera los cortes circulares a los costados del boleto.
struct TicketSeparator: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.addEllipse(in: CGRect(x: -10, y: 0, width: 20, height: 20))
        path.addEllipse(in: CGRect(x: rect.width - 10, y: 0, width: 20, height: 20))
        return path
    }
}

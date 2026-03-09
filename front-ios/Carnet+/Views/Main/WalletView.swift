//
//  WalletView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct WalletView: View {
    // Acceso al cerebro de la app inyectado desde MainTabView
    @EnvironmentObject var viewModel: EventViewModel
    
    var body: some View {
        NavigationStack {
            List {
                // SECCIÓN 1: BOLETOS PARA HOY O PRÓXIMOS
                Section {
                    if viewModel.activeTickets.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "ticket")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("No tienes boletos guardados.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        // HCI: Navegación directa para minimizar pasos del usuario
                        ForEach(viewModel.activeTickets) { evento in
                            NavigationLink(destination: TicketDetailView(evento: evento)) {
                                EventRow(evento: evento)
                            }
                        }
                    }
                } header: {
                    Text("Boletos Activos")
                }
                
                // SECCIÓN 2: HISTORIAL DE ASISTENCIA
                if !viewModel.ticketHistory.isEmpty {
                    Section {
                        ForEach(viewModel.ticketHistory) { evento in
                            EventRow(evento: evento)
                                .opacity(0.6) // HCI: Indica visualmente que es un evento pasado
                        }
                    } header: {
                        Text("Historial")
                    }
                }
            }
            .navigationTitle("Mis Boletos")
        }
    }
}

// Preview con inyección de dependencia para evitar errores de compilación
#Preview {
    WalletView()
        .environmentObject(EventViewModel())
}

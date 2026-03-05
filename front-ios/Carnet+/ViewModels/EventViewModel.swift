//
//  EventViewModel.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI
import Combine

class EventViewModel: ObservableObject {
    @Published var allEvents: [Evento] = []
    
    // Estos son para las alertas de registro
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    init() {
        loadSampleData()
    }

    func loadSampleData() {
        self.allEvents = [
            Evento(
                nombre: "Torneo Inter-UACH",
                descripcion: "Competencia de básquetbol.",
                fecha: .now.addingTimeInterval(3600),
                lugar: "Gimnasio",
                categoria: .deportivo, // Nombre actualizado
                esCupoLimitado: true,
                cupoMaximo: 20,
                cupoActual: 5,
                estaGuardado: true
            ),
            Evento(
                nombre: "Concierto Sinfónica",
                descripcion: "Música clásica en vivo.",
                fecha: .now.addingTimeInterval(86400),
                lugar: "Paraninfo",
                categoria: .artistico, // Nombre actualizado
                esCupoLimitado: false,
                estaGuardado: true
            )
        ]
    }

    // ESTA ES LA FUNCIÓN QUE XCODE NO ENCUENTRA
    func registerToEvent(eventID: UUID) {
        guard let index = allEvents.firstIndex(where: { $0.id == eventID }) else { return }
        
        if allEvents[index].hayCupo {
            allEvents[index].cupoActual += 1
            alertMessage = "¡Registro exitoso!"
            showAlert = true
        } else {
            alertMessage = "Evento lleno"
            showAlert = true
        }
    }
    
    // Filtros para las vistas
    var walletEvents: [Evento] {
        allEvents.filter { $0.estaGuardado }
    }
    
    var upcomingStories: [Evento] {
        allEvents // Por ahora mandamos todos para probar
    }
}

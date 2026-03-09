//
//  EventViewModel.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI
import Combine

/// ViewModel encargado de la lógica de negocio y filtrado de eventos.
/// HCI: Centraliza la 'fuente de verdad' para mantener la consistencia en toda la app.
class EventViewModel: ObservableObject {
    @Published var allEvents: [Evento] = []
    
    // Propiedades para feedback al usuario (HCI: Visibilidad del estado)
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    init() {
        load()
    }
    
    func load() {
        if FileManager.default.fileExists(atPath: savePath.path) {
                    do {
                        let data = try Data(contentsOf: savePath)
                        allEvents = try JSONDecoder().decode([Evento].self, from: data)
                    } catch {
                        print("Error al decodificar: \(error)")
                        loadSampleData()
                    }
                } else {
                    // HCI: Primera vez que se abre la app
                    loadSampleData()
                }
    }
    
    func save() {
            do {
                let data = try JSONEncoder().encode(allEvents)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error al guardar: \(error)")
            }
        }

    /// Solo se llama si no hay un archivo guardado previo
        func loadSampleData() {
            self.allEvents = [
                Evento(nombre: "Torneo Inter-UACH", descripcion: "Básquetbol.", fecha: .now.addingTimeInterval(3600), lugar: "Gimnasio", categoria: .deportivo, esCupoLimitado: true, cupoMaximo: 20, cupoActual: 5, estaGuardado: false), // Cambiado a false por defecto
                Evento(nombre: "Concierto Sinfónica", descripcion: "Música.", fecha: .now.addingTimeInterval(86400), lugar: "Paraninfo", categoria: .artistico, esCupoLimitado: false, estaGuardado: false)
            ]
        }

    /// Registra al alumno en un evento verificando disponibilidad.
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
    
    // MARK: - Propiedades Computadas (Filtros Inteligentes)
    
    /// Eventos marcados como favoritos por el alumno.
    var walletEvents: [Evento] {
        return allEvents.filter { $0.estaGuardado }
    }
    
    /// Boletos próximos: Guardados que aún no suceden y no han sido asistidos.
    /// HCI: Reducción de carga cognitiva al mostrar solo lo relevante.
    var activeTickets: [Evento] {
        return allEvents.filter { $0.estaGuardado && !$0.fueAsistido }
            .sorted { $0.fecha < $1.fecha }
    }
    
    /// Historial: Eventos pasados o marcados como asistidos.
    var ticketHistory: [Evento] {
        return allEvents.filter { $0.fueAsistido || ($0.estaGuardado && $0.fecha < Date()) }
            .sorted { $0.fecha > $1.fecha }
    }
    
    /// Historias: Todos los eventos disponibles para el carrusel de inicio.
    var upcomingStories: [Evento] {
        return allEvents
    }
    
    // MARK: - Persistencia (HCI: Prevención de pérdida de datos)

    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SavedEvents")
    
    /// Cambia el estado y guarda inmediatamente
        func toggleSave(for eventID: UUID) {
            if let index = allEvents.firstIndex(where: { $0.id == eventID }) {
                allEvents[index].estaGuardado.toggle()
                save() // HCI: Feedback inmediato y persistente
            }
        }
    
    /// Simula la asistencia al evento (esto lo haría el escáner del encargado).
    func checkIn(eventID: UUID) {
        if let index = allEvents.firstIndex(where: { $0.id == eventID }) {
            allEvents[index].fueAsistido = true
            save()
        }
    }
}

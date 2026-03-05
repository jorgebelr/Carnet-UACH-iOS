//
//  Evento.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

// Definimos las categorías con los colores oficiales del reporte
enum CategoriaEvento: String, CaseIterable, Codable {
    case artistico, cientifico, comunidad, deportivo, salud, vida
    
    // Vinculación directa con tus Assets
    var color: Color {
        return Color(self.rawValue) // Xcode busca "artistico", "cientifico", etc.
    }
    
    var nombre: String {
        switch self {
        case .artistico: return "Artístico"
        case .cientifico: return "Científico"
        case .comunidad: return "Comunidad"
        case .deportivo: return "Deportivo"
        case .salud: return "Salud"
        case .vida: return "Vida"
        }
    }
}
    
// El objeto que representa un evento individual
struct Evento: Identifiable, Codable {
    var id = UUID()
    let nombre: String
    let descripcion: String
    let fecha: Date
    let lugar: String
    let categoria: CategoriaEvento
    let esCupoLimitado: Bool
    var cupoMaximo: Int? // Opcional, si no es limitado es nil
    var cupoActual: Int = 0
    var estaGuardado: Bool = false
    var fueAsistido: Bool = false // Para el historial del Wallet
    
    // Lógica para el botón de "Solicitar Cortesía"
    var hayCupo: Bool {
        guard let max = cupoMaximo else { return true }
        return cupoActual < max
    }
}

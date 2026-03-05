//
//  MainTabView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct MainTabView: View {
    // Inicializamos el cerebro de la app aquí para que todas las pestañas lo compartan
    @StateObject private var viewModel = EventViewModel()
    
    var body: some View {
        TabView {
            // Pestaña 1: Home (Historias y Próximos)
            HomeView()
                .environmentObject(viewModel) // Pasamos el cerebro
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
            
            // Pestaña 2: Calendario (Exploración con filtros)
            CalendarView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Calendario", systemImage: "calendar")
                }
            
            // Pestaña 3: Wallet (Boletos con QR)
            WalletView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Mis Boletos", systemImage: "qrcode.viewfinder")
                }
        }
        // Color oficial para resaltar la navegación (puedes usar el de la UACH)
        .tint(Color("uach"))
    }
}

// El Preview para que veas las pestañas en el Canvas
#Preview {
    MainTabView()
}

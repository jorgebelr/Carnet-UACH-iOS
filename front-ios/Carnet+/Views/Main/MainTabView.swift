//
//  MainTabView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI
import UIKit
import AVFoundation

struct MainTabView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var selectedTab = 0
    
    // Feedback generators
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    private var player: AVAudioPlayer? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }.tag(0)
            // Calendar Tab
            CalendarView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Calendario", systemImage: "calendar")
                }.tag(1)
            // Wallet Tab
            WalletView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Mis Boletos", systemImage: "qrcode.viewfinder")
                }.tag(2)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .tint(Color("uach"))
        .onChange(of: selectedTab) {
            // Haptic feedback
            hapticGenerator.impactOccurred()
            
            // System sound feedback (short tap sound)
            AudioServicesPlaySystemSound(1104) // 1104 is a standard tap sound
        }
    }
}

// El Preview para que veas las pestañas en el Canvas
#Preview {
    MainTabView()
}

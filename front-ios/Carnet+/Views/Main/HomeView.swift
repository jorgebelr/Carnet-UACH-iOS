//
//  HomeView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI
import UserNotifications

// Helper for dashboard icons
private func iconForCategory(_ categoria: CategoriaEvento) -> String {
    switch categoria {
    case .artistico: return "paintbrush"
    case .cientifico: return "atom"
    case .comunidad: return "person.3.fill"
    case .deportivo: return "sportscourt"
    case .salud: return "cross.case.fill"
    case .vida: return "leaf"
    }
}

struct HomeView: View {
    @EnvironmentObject var viewModel: EventViewModel
    
    // Esta variable guarda el evento que el usuario seleccionó
    @State private var selectedStory: Evento?
    
    // Persistimos si ya solicitamos permiso de notificaciones
    @AppStorage("hasRequestedNotifications") private var hasRequestedNotifications: Bool = false
    
    // Totales por categoría (suman 38)
    private let totalByCategory: [CategoriaEvento: Int] = [
        .artistico: 6,
        .cientifico: 6,
        .comunidad: 6,
        .deportivo: 6,
        .salud: 6,
        .vida: 8
    ]
    
    // Simulación de completados por categoría solicitada
    private let simulatedCompletedByCategory: [CategoriaEvento: Int] = [
        .artistico: 3,
        .deportivo: 6,
        .comunidad: 2,
        .cientifico: 4,
        .salud: 4,
        .vida: 1
    ]
    
    // Helper for counting attended events
    private func countAttended(in categoria: CategoriaEvento) -> Int {
        min(simulatedCompletedByCategory[categoria] ?? 0, totalByCategory[categoria] ?? 0)
    }
    
    private var requiredEvents: Int { totalByCategory.values.reduce(0, +) }

    // Completados simulados sincronizados con los eventos asistidos del ViewModel y cap por total de categoría
    private var completedEvents: Int {
        var sum = 0
        for (categoria, total) in totalByCategory {
            let simulated = simulatedCompletedByCategory[categoria] ?? 0
            sum += min(simulated, total)
        }
        return sum
    }

    private var progressValue: Double {
        guard requiredEvents > 0 else { return 0 }
        return min(1.0, Double(completedEvents) / Double(requiredEvents))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    
                    // SECCIÓN 1: HISTORIAS (Próximos 7 días)
                    VStack(alignment: .leading) {
                        Text("Próximos Eventos")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.upcomingStories) { evento in
                                    // Aquí luego activaremos la ventana completa
                                    StoryCircle(evento: evento)
                                        .onTapGesture{
                                            selectedStory = evento
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 16) {

                        HStack {
                            VStack(alignment: .leading, spacing: 6) {

                                Text("Progreso Carnet")
                                    .font(.headline)

                                Text("\(completedEvents) de \(requiredEvents) eventos completados")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            ZStack {

                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .trim(from: 0, to: progressValue)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(
                                            lineWidth: 10,
                                            lineCap: .round
                                        )
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 70, height: 70)

                                Text("\(Int(progressValue * 100))%")
                                    .font(.headline.bold())
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 24,
                                style: .continuous
                            )
                        )
                    }
                    .padding(.horizontal)
                    
                    // DASHBOARD POR CATEGORÍA
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 12), count: 3), spacing: 16) {
                        ForEach(CategoriaEvento.allCases, id: \.self) { categoria in
                            Button(action: { /* Futuro: acción por categoría */ }) {
                                VStack(spacing: 4) {
                                    Image(systemName: iconForCategory(categoria))
                                        .font(.system(size: 26, weight: .medium))
                                        .foregroundColor(categoria.color)
                                    Text("\(countAttended(in: categoria))/\(totalByCategory[categoria] ?? 0)")
                                        .font(.title2.bold())
                                        .foregroundColor(.primary)
                                    Text(categoria.nombre)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    categoria.color.opacity(0.12)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            categoria.color.opacity(0.18),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(
                                    color: .black.opacity(0.05),
                                    radius: 8,
                                    y: 4
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // SECCIÓN 2: MIS EVENTOS (Guardados)
                    VStack(alignment: .leading) {
                        Text("Mi Agenda")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        if viewModel.walletEvents.isEmpty {
                            ContentUnavailableView(
                                "Sin eventos guardados",
                                systemImage: "bookmark",
                                description: Text("Explora el calendario para agregar eventos a tu carnet.")
                            )
                            .padding(.top, 40)
                        } else {
                            // Reutilizamos el EventRow que definimos antes
                                ForEach(viewModel.walletEvents) { evento in
                                    NavigationLink(destination: EventDetailView(evento: evento)) {
                                        EventRow(evento: evento)
                                            .padding(.horizontal)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain) // Evita que el renglón se ponga azul por ser un link
                                    
                                    Divider().padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .task {
                if !hasRequestedNotifications {
                    NotificationManager.shared.requestAuthorization()
                    hasRequestedNotifications = true
                }
            }
            .navigationTitle("Inicio")
            
            // Cuando selected story deja de ser nil, se abre la ventana
            .fullScreenCover(item: $selectedStory) { evento in
                StoryView(evento: evento, isPresented: Binding(
                    get: { selectedStory != nil }, // Solo devuelve si es nulo o no
                    set: { isPresenting in
                        if !isPresenting {
                            selectedStory = nil // Si se deja de presentar, limpiamos la variable
                        }
                    }
                ))
                .environmentObject(viewModel)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    HomeView()
        .environmentObject(EventViewModel())
}

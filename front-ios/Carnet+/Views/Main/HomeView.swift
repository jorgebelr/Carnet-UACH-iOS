//
//  HomeView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: EventViewModel
    
    // Esta variable guarda el evento que el usuario seleccionó
    @State private var selectedStory: Evento?
    
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
                                    }
                                    .buttonStyle(.plain) // Evita que el renglón se ponga azul por ser un link
                                    
                                    Divider().padding(.horizontal)
                            }
                        }
                    }
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
    }
}

#Preview {
    HomeView()
        .environmentObject(EventViewModel())
}

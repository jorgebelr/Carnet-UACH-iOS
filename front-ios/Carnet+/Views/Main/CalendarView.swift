//
//  CalendarView.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 04/03/26.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: EventViewModel
    @State private var selectedDate = Date()
    @State private var showDatePicker = false // Controla el Month-Picker

    var body: some View {
        VStack(spacing: 0) {
            // 1. SELECTOR DE FECHA INTELIGENTE
            HStack {
                // Botón Retroceder
                Button(action: { changeDate(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                }
                
                Spacer()
                
                // Botón Central (Muestra fecha y abre el calendario)
                Button(action: { showDatePicker.toggle() }) {
                    VStack {
                        Text(selectedDate.formatted(.dateTime.day().month(.wide)))
                            .font(.headline)
                        Text(selectedDate.formatted(.dateTime.year()))
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Botón Avanzar
                Button(action: { changeDate(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title3.bold())
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            // 2. LISTA FILTRADA POR DÍA
            List {
                let dailyEvents = viewModel.allEvents.filter {
                    Calendar.current.isDate($0.fecha, inSameDayAs: selectedDate)
                }
                
                if dailyEvents.isEmpty {
                    ContentUnavailableView(
                        "No hay eventos este día",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("Intenta buscar en otra fecha para completar tu carnet.")
                    )
                } else {
                    ForEach(dailyEvents) { evento in
                        EventRow(evento: evento)
                    }
                }
            }
        }
        .navigationTitle("Calendario")
        // Pop-up del calendario completo (Month-Picker)
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker(
                    "Selecciona una fecha",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button("Listo") { showDatePicker = false }
                    .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium])
        }
    }

    // Función para movernos día por día
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

#Preview {
    NavigationView {
        CalendarView()
            .environmentObject(EventViewModel())
    }
}

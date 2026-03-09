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
        NavigationStack {
            List {
                Section(header: dateSelector) {
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
                            NavigationLink(destination:
                                            //Creamo el portal hacia EventDetailView
                                            EventDetailView(evento: evento)) {
                                EventRow(evento: evento)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Calendario")
            .navigationBarTitleDisplayMode(.large)
            // Pop-up del calendario completo (Month-Picker)
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    CustomCalendarGrid(
                        selectedDate: $selectedDate,
                        hasEvent: { viewModel.hasEvent(on: $0) },
                        close: { showDatePicker = false }
                    )
                    Button("Listo") { showDatePicker = false }
                        .buttonStyle(.borderedProminent)
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    private var dateSelector: some View {
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
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(.systemBackground))
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


struct CustomCalendarGrid: View {
    @Binding var selectedDate: Date
    let hasEvent: (Date) -> Bool
    let close: () -> Void
    
    @State private var referenceDate = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal, 20)
                Text(monthYearString(referenceDate))
                    .font(.headline)
            }
            .padding(.top, 18)
            
            VStack {
                // Weekdays header
                HStack {
                    ForEach(["L", "M", "M", "J", "V", "S", "D"], id: \.self) { d in
                        Text(d)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, 8)

                // Calendar grid
                let days = daysInMonth(referenceDate)
                let firstWeekday = Calendar.current.component(.weekday, from: days.first ?? Date())
                let leading = (firstWeekday + 5) % 7 // Make Monday first
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                    ForEach(0..<(leading + days.count), id: \.self) { i in
                        if i < leading {
                            Color.clear.frame(height: 40)
                        } else {
                            let day = days[i - leading]
                            Button(action: {
                                selectedDate = day
                                close()
                            }) {
                                VStack(spacing: 3) {
                                    Text("\(Calendar.current.component(.day, from: day))")
                                        .font(.body.weight(day.isToday ? .bold : .regular))
                                        .foregroundColor(day.isToday ? .accentColor : .primary)
                                    if hasEvent(day) {
                                        Circle()
                                            .fill(Color.accentColor)
                                            .frame(width: 6, height: 6)
                                    } else {
                                        Spacer().frame(height: 6)
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(day.isSameDay(as: selectedDate) ? Color.accentColor.opacity(0.2) : .clear)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.top, 0)
            .padding()
        }
    }

    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: referenceDate) {
            withAnimation(.interactiveSpring()) {
                referenceDate = newDate
            }
        }
    }
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date).capitalized
    }
    private func daysInMonth(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: start)
        }
    }
}

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}

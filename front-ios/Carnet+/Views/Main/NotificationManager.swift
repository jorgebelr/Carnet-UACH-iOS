import Foundation
import UserNotifications
import Combine

enum ReminderOffset: Int, CaseIterable, Identifiable {
    case hours24 = 24
    case hours12 = 12
    case hour1 = 1
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .hours24:
            return "24 hours before"
        case .hours12:
            return "12 hours before"
        case .hour1:
            return "1 hour before"
        }
    }
    
    var timeInterval: TimeInterval {
        TimeInterval(rawValue * 3600)
    }
}

struct ScheduledReminderInfo {
    let eventID: String
    let offset: ReminderOffset
}

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() { }
    
    /// Requests authorization to display notifications
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion?(granted)
            }
        }
    }
    
    /// Schedules a local notification reminder for the specified event and offset
    /// - Parameters:
    ///   - eventID: Unique identifier for the event
    ///   - title: The name/title of the event
    ///   - eventDate: Date of the event
    ///   - offset: Reminder offset (how long before the event to notify)
    func scheduleReminder(for eventID: String, title: String, eventDate: Date, offset: ReminderOffset) {
        let content = UNMutableNotificationContent()
        
        // Compose notification body based on offset
        switch offset {
        case .hours24:
            content.title = "\(title) es mañana, no pierdas tu lugar!"
            content.body = "Recuerda que \(title) es dentro de 24 horas."
        case .hours12:
            content.title = "\(title) es en 12 horas, no pierdas tu lugar!"
            content.body = "Recuerda que \(title) es dentro de 12 horas."
        case .hour1:
            content.title = "\(title) es en 1 hora, no pierdas tu lugar!"
            content.body = "Recuerda que \(title) es dentro de 1 hora."
        }
        content.sound = .default
        
        // Calculate fire date = eventDate - offset
        let fireDate = eventDate.addingTimeInterval(-offset.timeInterval)
        
        // Guard against scheduling notifications in the past
        guard fireDate > Date() else {
            // The fire date is in the past, do not schedule
            return
        }
        
        // Extract date components for trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate)
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Notification identifier unique per eventID and offset
        let identifier = notificationIdentifier(for: eventID, offset: offset)
        
        // Create request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
        
        /*
         For demo/testing purposes:
         To test notifications firing quickly, replace the UNCalendarNotificationTrigger with:
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
         
         This will fire the notification 5 seconds after scheduling.
         
         Also, to change messages, modify the content.title and content.body strings above.
         */
    }
    
    /// Cancels scheduled reminder(s) for a given eventID (all offsets)
    /// - Parameter eventID: Unique identifier of the event
    func cancelReminder(for eventID: String) {
        let identifiers = ReminderOffset.allCases.map { notificationIdentifier(for: eventID, offset: $0) }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    /// Checks if there are any pending notification requests for the given eventID
    /// - Parameters:
    ///   - eventID: Unique identifier of the event
    ///   - completion: Closure with boolean indicating if any pending requests exist
    func pendingRequests(for eventID: String, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let ids = ReminderOffset.allCases.map { self.notificationIdentifier(for: eventID, offset: $0) }
            let hasPending = requests.contains { ids.contains($0.identifier) }
            DispatchQueue.main.async {
                completion(hasPending)
            }
        }
    }
    
    // MARK: - Private
    
    private func notificationIdentifier(for eventID: String, offset: ReminderOffset) -> String {
        return "\(eventID)_reminder_\(offset.rawValue)h"
    }
}

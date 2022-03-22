import Foundation
import MedicationContext

class EmptyNotificationService: NotificationService {
    func add(notification: ReminderNotification) {}
    func add(notifications: [ReminderNotification]) {}
    func removeAll() {}
}

import Foundation

public protocol NotificationService {
    func add(notification: ReminderNotification) async throws
    func add(notifications: [ReminderNotification]) async throws
    func remove(notification id: String)
    func remove(notificationsMatchingIds ids: [String])
}

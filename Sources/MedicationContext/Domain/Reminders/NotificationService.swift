import Foundation

public protocol NotificationService {
    func add(notification: ReminderNotification) async throws
    func add(notifications: [ReminderNotification]) async throws
    func removeAll() async throws
    func remove(notification id: String) async throws
    func remove(notificationsMatchingIds ids: [String]) async throws
}

extension NotificationService {
    public func add(notifications: [ReminderNotification]) async throws {
        for notification in notifications {
            try await add(notification: notification)
        }
    }
}

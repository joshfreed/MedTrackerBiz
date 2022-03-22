import Foundation
import UserNotifications
import MedicationContext
import OSLog

class LocalNotificationService {
    let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }
}

extension LocalNotificationService: NotificationService {
    public func add(notification: ReminderNotification) async throws {
        logger.debug("Added local notification to trigger at: \(notification.triggerDate)")
        try await UNUserNotificationCenter.current().add(notification.toNotificationRequest())
    }

    public func removeAll() {
        logger.debug("Removing all pending notifications")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension ReminderNotification {
    func toNotificationRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.body = body
        content.categoryIdentifier = "MEDICATION_CHECK_IN"
        content.userInfo["medicationId"] = medicationId

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        return UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    }
}

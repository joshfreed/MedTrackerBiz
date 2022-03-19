import Foundation
import UserNotifications
import MedicationContext

class LocalNotificationService {

}

extension LocalNotificationService: NotificationService {
    public func add(notification: ReminderNotification) async throws {
        try await UNUserNotificationCenter.current().add(notification.toNotificationRequest())
    }

    public func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    public func remove(notification id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    public func remove(notificationsMatchingIds ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
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

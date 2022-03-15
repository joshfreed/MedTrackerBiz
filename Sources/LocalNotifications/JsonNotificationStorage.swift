import Foundation
import MedicationContext

class JsonNotificationStorage {
    let notificationsUrl: URL
    private var notifications: [ReminderNotification] = []

    init() {
        let environment = ProcessInfo.processInfo.environment
        let resourcesDir = environment["SIMULATOR_SHARED_RESOURCES_DIRECTORY"]!
        notificationsUrl = URL(fileURLWithPath: "\(resourcesDir)/notifications.json")

        let data: Data
        do {
            data = try Data(contentsOf: notificationsUrl)
        } catch {
            let empty: [ReminderNotification] = []
            data = try! JSONEncoder().encode(empty)
        }
        notifications = try! JSONDecoder().decode([ReminderNotification].self, from: data)
    }

    private func save() throws {
        let jsonData = try JSONEncoder().encode(notifications)
        try jsonData.write(to: notificationsUrl)
    }
}

extension JsonNotificationStorage: NotificationService {
    func add(notification: ReminderNotification) async throws {
        notifications.append(notification)
        try save()
    }

    func remove(notification id: String) {
        notifications = notifications.filter { $0.id == id }
        try! save()
    }

    func remove(notificationsMatchingIds ids: [String]) {
        for id in ids {
            notifications = notifications.filter { $0.id == id }
        }
        try! save()
    }
}

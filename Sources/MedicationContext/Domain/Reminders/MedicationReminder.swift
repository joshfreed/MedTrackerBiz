import Foundation

public struct MedicationReminder: Equatable, Codable {
    public let reminderTime: ReminderTime

    public init(reminderTime: ReminderTime) {
        self.reminderTime = reminderTime
    }
}

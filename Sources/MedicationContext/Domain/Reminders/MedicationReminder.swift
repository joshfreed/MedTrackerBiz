import Foundation

public struct MedicationReminder: Equatable, Codable {
    public let reminderTime: ReminderTime

    public init(reminderTime: ReminderTime) {
        self.reminderTime = reminderTime
    }

    func reminderTrigger(for date: Date, calendar: Calendar = .current) throws -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = reminderTime.hour
        dateComponents.minute = reminderTime.minute
        dateComponents.second = 0

        guard let triggerDate = calendar.date(from: dateComponents) else {
            throw DateError.invalidDate
        }

        return triggerDate
    }
}

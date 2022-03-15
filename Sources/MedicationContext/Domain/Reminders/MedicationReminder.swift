import Foundation

public struct MedicationReminder: Equatable, Codable {
    public let reminderTime: ReminderTime

    private let numberOfDaysToSchedule = 5

    public init(reminderTime: ReminderTime) {
        self.reminderTime = reminderTime
    }

    func scheduleNotifications(includeToday: Bool, calendar: Calendar = .current) throws -> [Date] {
        var triggerDates: [Date] = []
        var date = includeToday && canTriggerToday() ? Date.current : Date.current.tomorrow(calendar: calendar)

        for _ in 0..<numberOfDaysToSchedule {
            let triggerDate = try reminderTrigger(for: date, calendar: calendar)
            triggerDates.append(triggerDate)
            date = date.tomorrow(calendar: calendar)
        }

        return triggerDates
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

    /// Returns true if this reminder can still be triggered today. A reminder can be triggered if it's reminder time is after the current time.
    func canTriggerToday() -> Bool {
        reminderTime.canTriggerToday()
    }
}

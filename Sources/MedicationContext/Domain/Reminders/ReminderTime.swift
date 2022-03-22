import Foundation

public struct ReminderTime: Equatable, Codable {
    public let hour: Int
    public let minute: Int

    public init(hour: Int, minute: Int) throws {
//        guard administrationTime >= 0 && administrationTime < 24 else {
//            throw MedicationError.invalidAdministrationTime
//        }

        self.hour = hour
        self.minute = minute
    }

    public init(date: Date, calendar: Calendar = Calendar.current) {
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
    }

    /// Returns true if this reminder can still be triggered today. A reminder can be triggered if it's reminder time is after the current time.
    func canTriggerToday() -> Bool {
        if Date.current.hour < hour { return true }
        if Date.current.hour == hour && Date.current.minute < minute { return true }
        return false
    }

    func toDate() -> Date {
        Calendar.current.date(from: .init(hour: hour, minute: minute, second: 0))!
    }
}

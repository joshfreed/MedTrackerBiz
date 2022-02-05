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
}

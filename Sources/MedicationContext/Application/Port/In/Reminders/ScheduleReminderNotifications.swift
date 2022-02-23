import Foundation

public struct ScheduleReminderNotificationsCommand {
    public let medicationId: String

    public init(medicationId: String) {
        self.medicationId = medicationId
    }
}

public protocol ScheduleReminderNotificationsUseCase {
    func handle(_ command: ScheduleReminderNotificationsCommand) async throws
}

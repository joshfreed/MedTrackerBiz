import Foundation

public struct ScheduleReminderNotificationsCommand {
    public let medicationId: String

    public init(medicationId: String) {
        self.medicationId = medicationId
    }
}

public struct ScheduleAllReminderNotificationsCommand {
    public init() {}
}

public protocol ScheduleReminderNotificationsUseCase {
    func handle(_ command: ScheduleReminderNotificationsCommand) async throws
    func handle(_ command: ScheduleAllReminderNotificationsCommand) async throws
}

import Foundation

public class RemindersService: ScheduleReminderNotificationsUseCase {
    private let scheduler: DailyReminderNotificationScheduler

    public init(scheduler: DailyReminderNotificationScheduler) {
        self.scheduler = scheduler
    }

    public func handle(_ command: ScheduleReminderNotificationsCommand) async throws {
        try await scheduler.scheduleNotifications(for: command.medicationId, startingOn: Date.current)
    }
}

import Foundation
import JFLib_DomainEvents

public enum NotificationSchedulingEventHandlers {
    public class NewMedicationTrackedHandler: DomainEventHandler<NewMedicationTracked> {
        let useCase: ScheduleReminderNotificationsUseCase

        public init(useCase: ScheduleReminderNotificationsUseCase) {
            self.useCase = useCase
            super.init()
        }

        override public func handle(event: NewMedicationTracked) {
            Task {
                do {
                    try await useCase.handle(ScheduleReminderNotificationsCommand(medicationId: event.id))
                } catch {
                    fatalError()
                }
            }
        }
    }
}

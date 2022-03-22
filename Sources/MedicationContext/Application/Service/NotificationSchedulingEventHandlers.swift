import Foundation
import JFLib_DomainEvents
import MTBackEndCore

public enum NotificationSchedulingEventHandlers {
    public class NewMedicationTrackedHandler: DomainEventHandler<NewMedicationTracked> {
        let remindersService: RemindersService

        public init(remindersService: RemindersService) {
            self.remindersService = remindersService
            super.init()
        }

        override public func handle(event: NewMedicationTracked) {
            Task {
                do {
                    try await remindersService.handle(ScheduleReminderNotificationsCommand(medicationId: event.id))
                } catch {
                    fatalError()
                }
            }
        }
    }

    public class AdministrationRecordedHandler: DomainEventHandler<AdministrationRecorded> {
        let remindersService: RemindersService

        public init(remindersService: RemindersService) {
            self.remindersService = remindersService
            super.init()
        }

        override public func handle(event: AdministrationRecorded) {
            Task {
                do {
                    try await remindersService.handle(ScheduleReminderNotificationsCommand(medicationId: event.medicationId.description))
                } catch {
                    fatalError()
                }
            }
        }
    }

    public class AdministrationRemovedHandler: DomainEventHandler<AdministrationRemoved> {
        let remindersService: RemindersService

        public init(remindersService: RemindersService) {
            self.remindersService = remindersService
            super.init()
        }

        override public func handle(event: AdministrationRemoved) {
            Task {
                do {
                    try await remindersService.handle(ScheduleReminderNotificationsCommand(medicationId: event.medicationId.description))
                } catch {
                    fatalError()
                }
            }
        }
    }

    public class MedicationUpdatedHandler: DomainEventHandler<MedicationUpdated> {
        let remindersService: RemindersService

        public init(remindersService: RemindersService) {
            self.remindersService = remindersService
            super.init()
        }

        override public func handle(event: MedicationUpdated) {
            Task {
                do {
                    try await remindersService.handle(ScheduleReminderNotificationsCommand(medicationId: event.id))
                } catch {
                    fatalError()
                }
            }
        }
    }
}

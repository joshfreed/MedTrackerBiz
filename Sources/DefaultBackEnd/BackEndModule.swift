import Foundation
import Dip
import JFLib_Services
import JFLib_DomainEvents
import MTCommon
import MTBackEndCore
import MedicationContext
import CoreDataKit

public class BackEndModule: MedTrackerModule {
    public init() {}

    public func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        container.register(.singleton) { DefaultBackEnd() }.implements(MedTrackerBackEnd.self)
        container.register(.singleton) { DefaultDomainEvents() }.implements(MedTrackerBackEndEvents.self)

        container.register(.singleton) { MedicationService(medications: $0, administrations: $1) }
        container.register(.singleton) { RemindersService(scheduler: $0) }

        container.register { NotificationSchedulingEventHandlers.NewMedicationTrackedHandler(remindersService: $0) }
        container.register { NotificationSchedulingEventHandlers.AdministrationRecordedHandler(remindersService: $0) }
        container.register { NotificationSchedulingEventHandlers.AdministrationRemovedHandler(remindersService: $0) }
        container.register { NotificationSchedulingEventHandlers.MedicationUpdatedHandler(remindersService: $0) }

        container.register {
            DailyReminderNotificationScheduler(notificationService: $0, medicationRepository: $1, administrationRepository: $2)
        }

        switch env {
        case .live:
            container.register(.singleton) { PersistenceController.shared.container.viewContext }
            container.register { CoreDataMedications(context: $0) }.implements(MedicationRepository.self)
            container.register { CoreDataAdministrations(context: $0) }.implements(AdministrationRepository.self)
        case .test:
            container.register(.singleton) { PersistenceController.testing.container.viewContext }
            container.register { CoreDataMedications(context: $0) }.implements(MedicationRepository.self)
            container.register { CoreDataAdministrations(context: $0) }.implements(AdministrationRepository.self)
        case .preview:
            container.register { MemoryMedications() }.implements(MedicationRepository.self)
            container.register { MemoryAdministrations() }.implements(AdministrationRepository.self)
        }
    }

    public func bootstrap(env: XcodeEnvironment) {
        DomainEventPublisher.shared.subscribe(DomainEventForwarder())
        addReminderSubscribers()
    }

    private func addReminderSubscribers() {
        let handler1 = try! JFServices.resolve() as NotificationSchedulingEventHandlers.NewMedicationTrackedHandler
        let handler2 = try! JFServices.resolve() as NotificationSchedulingEventHandlers.AdministrationRecordedHandler
        let handler3 = try! JFServices.resolve() as NotificationSchedulingEventHandlers.AdministrationRemovedHandler
        let handler4 = try! JFServices.resolve() as NotificationSchedulingEventHandlers.MedicationUpdatedHandler
        DomainEventPublisher.shared.subscribe(handler1)
        DomainEventPublisher.shared.subscribe(handler2)
        DomainEventPublisher.shared.subscribe(handler3)
        DomainEventPublisher.shared.subscribe(handler4)
    }
}

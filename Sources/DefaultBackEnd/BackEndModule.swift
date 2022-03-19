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
        container.register(.singleton) {
            DefaultBackEnd(
                trackMedication: $0,
                getTrackedMedicationsQuery: $1,
                getTrackedMedications: $2,
                recordAdministration: $3,
                removeAdministration: $4,
                scheduleRemindersUseCase: $5
            )
        }
        .implements(MedTrackerBackEnd.self)

        container.register(.singleton) { DefaultDomainEvents() }.implements(MedTrackerBackEndEvents.self)

        container
            .register(.singleton) {
                MedicationService(medications: $0, administrations: $1)
            }
            .implements(
                GetTrackedMedicationsContinuousQuery.self,
                RecordAdministrationUseCase.self,
                RemoveAdministrationUseCase.self,
                TrackMedicationUseCase.self
            )
            .implements(GetTrackedMedicationsUseCase.self)

        container.register { NotificationSchedulingEventHandlers.NewMedicationTrackedHandler(useCase: $0) }
        container.register { NotificationSchedulingEventHandlers.AdministrationRecordedHandler(useCase: $0) }
        container.register { NotificationSchedulingEventHandlers.AdministrationRemovedHandler(useCase: $0) }

        container.register(.singleton) {
            RemindersService(scheduler: $0)
        }.implements(ScheduleReminderNotificationsUseCase.self)

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
        DomainEventPublisher.shared.subscribe(handler1)
        DomainEventPublisher.shared.subscribe(handler2)
        DomainEventPublisher.shared.subscribe(handler3)
    }
}

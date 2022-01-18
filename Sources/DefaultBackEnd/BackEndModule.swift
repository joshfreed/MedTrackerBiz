import Foundation
import Dip
import JFLib_Services
import JFLib_DomainEvents
import Common
import MedTrackerBackEnd
import MedicationApp
import CoreDataKit

public class BackEndModule {
    public init() {}

    public func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        container.register(.singleton) {
            DefaultBackEnd(
                trackMedication: $0,
                getTrackedMedicationsQuery: $1,
                getTrackedMedications: $2,
                recordAdministration: $3,
                removeAdministration: $4
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
    }
}

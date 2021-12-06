import Foundation
import JFLib_DomainEvents

struct AdministrationRecorded: DomainEvent, Equatable {
    let id: AdministrationId
    let medicationId: MedicationId
    let administrationDate: Date
}

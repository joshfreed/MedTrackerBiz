import Foundation
import JFLib_DomainEvents

struct AdministrationRecorded: DomainEvent {
    let id: AdministrationId
    let medicationId: MedicationId
    let administrationDate: Date
}

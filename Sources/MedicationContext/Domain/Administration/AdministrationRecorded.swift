import Foundation
import JFLib_DomainEvents

public struct AdministrationRecorded: DomainEvent, Equatable {
    public let id: AdministrationId
    public let medicationId: MedicationId
    public let administrationDate: Date
    public let medicationName: String
}

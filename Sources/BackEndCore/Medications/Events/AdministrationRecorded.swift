import Foundation
import JFLib_DomainEvents

public struct AdministrationRecorded: DomainEvent, Equatable {
    public let id: String
    public let medicationId: String
    public let administrationDate: Date
    public let medicationName: String

    public init(id: String, medicationId: String, administrationDate: Date, medicationName: String) {
        self.id = id
        self.medicationId = medicationId
        self.administrationDate = administrationDate
        self.medicationName = medicationName
    }
}

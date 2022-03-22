import Foundation
import JFLib_DomainEvents

public struct AdministrationRemoved: DomainEvent, Equatable {
    public let administrationId: String
    public let medicationId: String

    public init(administrationId: String, medicationId: String) {
        self.administrationId = administrationId
        self.medicationId = medicationId
    }
}

import Foundation
import JFLib_DomainEvents

public struct AdministrationRemoved: DomainEvent, Equatable {
    public let administrationId: String
    public let medicationId: String
}

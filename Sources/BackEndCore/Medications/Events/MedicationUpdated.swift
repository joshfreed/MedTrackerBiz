import Foundation
import JFLib_DomainEvents

public struct MedicationUpdated: DomainEvent, Equatable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}

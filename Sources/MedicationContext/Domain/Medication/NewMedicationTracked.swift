import Foundation
import JFLib_DomainEvents

public struct NewMedicationTracked: DomainEvent, Equatable {
    public let id: String
    public let name: String
}

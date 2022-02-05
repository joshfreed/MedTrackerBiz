import Foundation

public struct RemoveAdministrationCommand {
    public let medicationId: String

    public init(medicationId: String) {
        self.medicationId = medicationId
    }
}

public protocol RemoveAdministrationUseCase {
    func handle(_ command: RemoveAdministrationCommand) async throws
}

public enum RemoveAdministrationError: Error {
    case invalidMedicationId
    case medicationNotFound
    case administrationNotFound
}

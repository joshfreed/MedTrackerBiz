import Foundation

public struct RecordAdministrationCommand {
    public let medicationId: String

    public init(medicationId: String) {
        self.medicationId = medicationId
    }
}

public protocol RecordAdministrationUseCase {
    func handle(_ command: RecordAdministrationCommand) async throws
}

public enum RecordAdministrationError: Error {
    case invalidMedicationId
    case medicationNotFound
}

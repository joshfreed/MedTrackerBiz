import Foundation

public struct RecordAdministrationCommand: Equatable {
    public let medicationId: String

    public init(medicationId: String) {
        self.medicationId = medicationId
    }
}

public struct RecordAdministrationByNameCommand: Equatable {
    public let medicationName: String

    public init(medicationName: String) {
        self.medicationName = medicationName
    }
}

public protocol RecordAdministrationUseCase {
    func handle(_ command: RecordAdministrationCommand) async throws
    func handle(_ command: RecordAdministrationByNameCommand) async throws
}

public enum RecordAdministrationError: Error {
    case invalidMedicationId
    case medicationNotFound
    case administrationAlreadyRecorded
}

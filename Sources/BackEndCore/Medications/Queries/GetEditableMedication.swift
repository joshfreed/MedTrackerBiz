import Foundation

public struct GetEditableMedicationQuery {
    public let medicationId: String

    public init(medicationId: String) {
        self.medicationId = medicationId
    }
}

public struct GetEditableMedicationResponse {
    public let name: String
    public let reminderTime: Date?

    public init(name: String, reminderTime: Date?) {
        self.name = name
        self.reminderTime = reminderTime
    }
}

import Foundation

public struct UpdateMedicationCommand {
    public let medicationId: String
    public let name: String
    public let reminderTime: Date?

    public init(medicationId: String, name: String, reminderTime: Date?) {
        self.medicationId = medicationId
        self.name = name
        self.reminderTime = reminderTime
    }
}

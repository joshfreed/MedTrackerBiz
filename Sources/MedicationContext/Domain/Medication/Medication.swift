import Foundation
import JFLib_DomainEvents

/// Represents a medication that must be administered
public struct Medication: Equatable, Codable {
    public let id: MedicationId

    /// The name of the medication
    public private(set) var name: String

    public private(set) var reminder: MedicationReminder?

    public init(name: String) {
        self.init(id: MedicationId(), name: name)
    }

    init(id: MedicationId, name: String) {
        self.id = id
        self.name = name
    }

    public static func ==(lhs: Medication, rhs: Medication) -> Bool {
        lhs.id == rhs.id
    }

    /// Records a new administration of this medication at the given date and time.
    ///
    /// - Parameter date: The exact date and time the medication as administered
    /// - Returns: an entity representing the new administration
    func recordAdministration(on date: Date) -> Administration {
        let administration = Administration(medicationId: id)
        DomainEvents.add(AdministrationRecorded(
            id: administration.id,
            medicationId: id,
            administrationDate: administration.administrationDate,
            medicationName: name
        ))
        return administration
    }

    mutating func enableReminderNotifications(at reminderTime: ReminderTime) {
        reminder = MedicationReminder(reminderTime: reminderTime)
    }

    mutating func disableReminderNotifications() {
        reminder = nil
    }

    func scheduleReminderNotifications(wasAdministered: Bool) throws -> [ReminderNotification] {
        guard let reminder = reminder else { return [] }

        let today = Date.current

        var triggerDate = try reminder.reminderTrigger(for: today)

        let body = "Have you taken your \(name) today?"

        var notifications: [ReminderNotification] = []

        for index in 0..<5 {
            let notification = ReminderNotification(
                id: "\(id)_\(index)",
                medicationId: String(describing: id),
                body: body,
                triggerDate: triggerDate
            )
            notifications.append(notification)
            triggerDate = triggerDate.addingTimeInterval(24.hours)
        }

        return notifications
    }
}

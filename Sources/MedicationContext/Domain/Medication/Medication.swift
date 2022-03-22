import Foundation
import JFLib_DomainEvents
import MTBackEndCore

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
            id: administration.id.description,
            medicationId: id.description,
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

        let reminderDates = try reminder.scheduleNotifications(includeToday: !wasAdministered)

        return buildDailyReminderNotifications(for: reminderDates)
    }

    private func buildDailyReminderNotifications(for reminderDates: [Date]) -> [ReminderNotification] {
        var notifications: [ReminderNotification] = []

        let body = "Have you taken your \(name) today?"

        for index in 0..<reminderDates.count {
            let notification = ReminderNotification(
                id: "\(id)_\(index)",
                medicationId: String(describing: id),
                body: body,
                triggerDate: reminderDates[index]
            )
            notifications.append(notification)
        }

        return notifications
    }
}

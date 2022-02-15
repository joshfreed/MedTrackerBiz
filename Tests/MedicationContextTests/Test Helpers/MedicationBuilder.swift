import Foundation
@testable import MedicationContext

class MedicationBuilder {
    private var id = MedicationId()
    private var name = "Random Name"
    private var reminderTime: ReminderTime?

    static func aMedication() -> MedicationBuilder {
        MedicationBuilder()
    }

    func build() -> Medication {
        var medication = Medication(id: id, name: name)
        if let reminderTime = reminderTime {
            medication.enableReminderNotifications(at: reminderTime)
        }
        return medication
    }

    func with(id: MedicationId) -> MedicationBuilder {
        self.id = id
        return self
    }

    func with(name: String) -> MedicationBuilder {
        self.name = name
        return self
    }

    func withRemindersEnabled(at reminderTime: ReminderTime) -> MedicationBuilder {
        self.reminderTime = reminderTime
        return self
    }
}

import Foundation
import CoreData
import MedicationContext

@objc(CDMedicationReminder)
public class CDMedicationReminder: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMedicationReminder> {
        return NSFetchRequest<CDMedicationReminder>(entityName: "CDMedicationReminder")
    }

    @NSManaged public var reminderHour: Int16
    @NSManaged public var reminderMinute: Int16

    func fromDomainModel(_ reminder: MedicationReminder) {
        reminderHour = Int16(reminder.reminderTime.hour)
        reminderMinute = Int16(reminder.reminderTime.minute)
    }

    func toJSON() -> [String: Any] {
        [
            "reminderTime": [
                "hour": reminderHour,
                "minute": reminderMinute
            ],
        ]
    }

    func toDomainModel() throws -> MedicationReminder {
        let data = try JSONSerialization.data(withJSONObject: toJSON(), options: [])
        return try JSONDecoder().decode(MedicationReminder.self, from: data)
    }
}

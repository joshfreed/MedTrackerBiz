import Foundation
import CoreData
import MedicationContext
import OSLog

@objc(CDMedication)
public class CDMedication: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMedication> {
        return NSFetchRequest<CDMedication>(entityName: "CDMedication")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var reminder: CDMedicationReminder?

    func fromDomainModel(_ medication: Medication) {
        id = medication.id.uuid
        name = medication.name

        if let medicationReminder = medication.reminder {
            reminder = CDMedicationReminder(context: managedObjectContext!)
            reminder?.fromDomainModel(medicationReminder)
        } else if let cdReminder = reminder {
            managedObjectContext?.delete(cdReminder)
            reminder = nil
        }
    }

    func toJSON() -> [String: Any] {
        guard let id = id, let name = name else {
            Logger.coreData.error("Got nil properties in CDMedication that should not be nil")
            return [:]
        }

        var values: [String: Any] = [
            "id": ["uuid": id.uuidString],
            "name": name,
        ]

        if let reminder = reminder {
            values["reminder"] = reminder.toJSON()
        }

        return values
    }

    func toDomainModel() throws -> Medication {
        let data = try JSONSerialization.data(withJSONObject: toJSON(), options: [])
        return try JSONDecoder().decode(Medication.self, from: data)
    }
}

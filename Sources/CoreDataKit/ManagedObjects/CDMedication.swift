//
//  CDMedication.swift
//  MedTracker
//
//  Created by Josh Freed on 12/31/21.
//
//

import Foundation
import CoreData
import MedicationContext

@objc(CDMedication)
public class CDMedication: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMedication> {
        return NSFetchRequest<CDMedication>(entityName: "CDMedication")
    }

    @NSManaged public var administrationHour: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

    func fromDomainModel(_ medication: Medication) {
        id = medication.id.uuid
        name = medication.name
        administrationHour = Int16(medication.administrationTime)
    }

    func toDomainModel() throws -> Medication {
        let values: [String: Any] = [
            "id": ["uuid": id!.uuidString],
            "name": name!,
            "administrationTime": Int(administrationHour)
        ]
        let data = try JSONSerialization.data(withJSONObject: values, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(Medication.self, from: data)
    }
}

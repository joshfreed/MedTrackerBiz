//
//  CDAdministration.swift
//  MedTracker
//
//  Created by Josh Freed on 12/31/21.
//
//

import Foundation
import CoreData
import MedicationContext

@objc(CDAdministration)
public class CDAdministration: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAdministration> {
        return NSFetchRequest<CDAdministration>(entityName: "CDAdministration")
    }

    @NSManaged public var administrationDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var medicationId: UUID?

    func fromDomainModel(_ administration: Administration) {
        id = administration.id.uuid
        medicationId = administration.medicationId.uuid
        administrationDate = administration.administrationDate
    }

    func toDomainModel() throws -> Administration {
        let values: [String: Any] = [
            "id": ["uuid": id!.uuidString],
            "medicationId": ["uuid": medicationId!.uuidString],
            "administrationDate": administrationDate!.timeIntervalSinceReferenceDate
        ]
        let data = try JSONSerialization.data(withJSONObject: values, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(Administration.self, from: data)
    }
}

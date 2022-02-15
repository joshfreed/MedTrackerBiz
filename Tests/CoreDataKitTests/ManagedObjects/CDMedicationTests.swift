import XCTest
@testable import MedicationContext
@testable import CoreDataKit

class CDMedicationTests: XCTestCase {
    lazy private var context = PersistenceController.testing.container.viewContext

    func test_map_from_domain_model() throws {
        let name = "My Med"
        let domainObject = Medication(name: name)
        let managedObject = CDMedication(context: context)

        managedObject.fromDomainModel(domainObject)

        XCTAssertEqual(domainObject.id.uuid, managedObject.id)
        XCTAssertEqual(name, managedObject.name)
        XCTAssertNil(managedObject.reminder)
    }

    func test_maps_medication_reminder_relationship() throws {
        var domainObject = Medication(name: "Anything")
        domainObject.enableReminderNotifications(at: try .init(hour: 9, minute: 15))
        let managedObject = CDMedication(context: context)

        managedObject.fromDomainModel(domainObject)

        XCTAssertNotNil(managedObject.reminder)
        XCTAssertEqual(9, managedObject.reminder?.reminderHour)
        XCTAssertEqual(15, managedObject.reminder?.reminderMinute)
    }
}

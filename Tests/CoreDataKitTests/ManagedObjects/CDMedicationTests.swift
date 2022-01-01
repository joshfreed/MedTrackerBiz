import XCTest
import MedicationApp
@testable import CoreDataKit

class CDMedicationTests: XCTestCase {
    func test_map_from_domain_model() throws {
        let name = "My Med"
        let hour = 11
        let domainObject = try Medication(name: name, administrationTime: hour)
        let context = PersistenceController.testing.container.viewContext
        let managedObject = CDMedication(context: context)

        managedObject.fromDomainModel(domainObject)

        XCTAssertEqual(domainObject.id.uuid, managedObject.id)
        XCTAssertEqual(name, managedObject.name)
        XCTAssertEqual(11, managedObject.administrationHour)
    }
}

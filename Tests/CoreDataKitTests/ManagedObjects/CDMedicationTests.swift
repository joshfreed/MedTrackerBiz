import XCTest
import MedicationContext
@testable import CoreDataKit

class CDMedicationTests: XCTestCase {
    func test_map_from_domain_model() throws {
        let name = "My Med"
        let domainObject = Medication(name: name)
        let context = PersistenceController.testing.container.viewContext
        let managedObject = CDMedication(context: context)

        managedObject.fromDomainModel(domainObject)

        XCTAssertEqual(domainObject.id.uuid, managedObject.id)
        XCTAssertEqual(name, managedObject.name)
    }
}

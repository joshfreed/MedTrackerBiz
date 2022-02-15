import XCTest
@testable import MedicationContext
@testable import CoreDataKit
import CoreData

class CoreDataMedicationsTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private var sut: CoreDataMedications!
    private let medicationId = MedicationId()
    private lazy var medication = Medication(id: medicationId, name: "Tylenol")

    override func setUpWithError() throws {
        context = PersistenceController.testing.container.viewContext
        sut = CoreDataMedications(context: context)
    }

    // MARK: add

    func test_add_medication() async throws {
        try await sut.add(medication)

        let entity = try fetchMedication(byId: medicationId)
        XCTAssertNotNil(entity)
        XCTAssertEqual(medicationId.uuid, entity?.id)
        XCTAssertEqual("Tylenol", entity?.name)
        XCTAssertNil(entity?.reminder)
    }

    func test_add_medication_with_reminder() async throws {
        medication.enableReminderNotifications(at: try .init(hour: 11, minute: 31))

        try await sut.add(medication)

        let entity = try fetchMedication(byId: medicationId)
        XCTAssertNotNil(entity)
        XCTAssertEqual(medicationId.uuid, entity?.id)
        XCTAssertEqual("Tylenol", entity?.name)
        XCTAssertNotNil(entity?.reminder)
        XCTAssertEqual(11, entity?.reminder?.reminderHour)
        XCTAssertEqual(31, entity?.reminder?.reminderMinute)
    }

    // MARK: Helpers

    private func fetchMedication(byId id: MedicationId) throws -> CDMedication? {
        let request = CDMedication.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id.uuid as CVarArg)
        return try context.fetch(request).first
    }
}

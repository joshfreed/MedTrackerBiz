import XCTest
@testable import JFLib_Testing
import JFLib_DomainEvents
@testable import MedicationContext

class MedicationTests: XCTestCase {
    let today = Date()

    override func setUpWithError() throws {
        Date.overrideCurrentDate(self.today)
    }

    override func tearDownWithError() throws {
    }

    // MARK: initialize

    func test_initialize_medication() throws {
        let medicationId = MedicationId()
        let name = "Awesome Pills"
        let administrationHour = 11
        let medication = try Medication(
            id: medicationId,
            name: name,
            administrationTime: administrationHour
        )
        XCTAssertEqual(medicationId, medication.id)
        XCTAssertEqual(name, medication.name)
        XCTAssertEqual(administrationHour, medication.administrationTime)
    }

    func test_initialize_throws_error_if_administrationTime_is_too_high() throws {
        do {
            _ = try Medication(id: MedicationId(), name: "Anything", administrationTime: 24)
            XCTFail("Expected invalidAdministrationTime error to be thrown")
        } catch MedicationError.invalidAdministrationTime {
            // Success!
        }
    }

    func test_initialize_throws_error_if_administrationTime_is_too_low() throws {
        do {
            _ = try Medication(id: MedicationId(), name: "Anything", administrationTime: -1)
            XCTFail("Expected invalidAdministrationTime error to be thrown")
        } catch MedicationError.invalidAdministrationTime {
            // Success!
        }
    }

    func test_initialize_administrationTime_zero_is_okay() throws {
        _ = try Medication(id: MedicationId(), name: "Anything", administrationTime: 0)
    }

    // MARK: recordAdministration

    func test_recordAdministration_creates_a_new_administration_instances() {
        let medication = MedicationBuilder.aMedication().build()

        let administration = medication.recordAdministration(on: today)

        XCTAssertEqual(administration.medicationId, medication.id)
        XCTAssertEqual(administration.administrationDate, today)
    }

    func test_recordAdministration_publishes_a_domain_event() {
        // Given
        var publishedEvent: AdministrationRecorded?
        let medication = MedicationBuilder.aMedication().build()
        DomainEventPublisher.shared.subscribe(DomainEventSubscriber<AdministrationRecorded> { domainEvent in
            publishedEvent = domainEvent
        })

        // When
        let administration = medication.recordAdministration(on: today)
        DomainEventPublisher.shared.publishPendingEvents()

        // Then
        XCTAssertNotNil(publishedEvent)
        XCTAssertEqual(publishedEvent?.id, administration.id)
        XCTAssertEqual(publishedEvent?.medicationId, medication.id)
        XCTAssertEqual(publishedEvent?.administrationDate, today)
    }
}

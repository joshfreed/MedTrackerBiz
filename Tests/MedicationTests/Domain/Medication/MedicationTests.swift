import XCTest
@testable import JFLib_Testing
import JFLib_DomainEvents
@testable import MedicationApp

class MedicationTests: XCTestCase {
    let today = Date()

    override func setUpWithError() throws {
        Date.overrideCurrentDate(self.today)
    }

    override func tearDownWithError() throws {
    }

    // MARK: recordAdministration

    func test_recordAdministration_creates_a_new_administration_instances() {
        let medication = Medication(name: "Awesome Pills")

        let administration = medication.recordAdministration(on: today)

        XCTAssertEqual(administration.medicationId, medication.id)
        XCTAssertEqual(administration.administrationDate, today)
    }

    func test_recordAdministration_publishes_a_domain_event() {
        // Given
        var publishedEvent: AdministrationRecorded?
        let medication = Medication(name: "Awesome Pills")
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

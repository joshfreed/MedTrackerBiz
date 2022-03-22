import XCTest
@testable import JFLib_Testing
import JFLib_DomainEvents
@testable import MedicationContext
import MTBackEndCore

class MedicationTests: XCTestCase {
    let today = Date()

    override func setUpWithError() throws {
        Date.overrideCurrentDate(self.today)
    }

    override func tearDownWithError() throws {
    }

    // MARK: - initialize

    func test_initialize_medication() throws {
        let medicationId = MedicationId()
        let name = "Awesome Pills"
        let medication = Medication(id: medicationId, name: name)
        XCTAssertEqual(medicationId, medication.id)
        XCTAssertEqual(name, medication.name)
    }

    // MARK: - recordAdministration

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
        XCTAssertEqual(publishedEvent?.id, administration.id.description)
        XCTAssertEqual(publishedEvent?.medicationId, medication.id.description)
        XCTAssertEqual(publishedEvent?.administrationDate, today)
    }

    // MARK: - scheduleReminderNotifications

    func test_scheduleReminderNotifications_notAdministeredToday() throws {
        // Given
        let reminderTime = try ReminderTime(hour: 9, minute: 15)
        let medication = MedicationBuilder.aMedication()
            .withRemindersEnabled(at: reminderTime)
            .build()
        let now = try Date.factory(year: 2022, month: 1, day: 29, hour: 6, minute: 13, second: 34)
        Date.overrideCurrentDate(now)

        // When
        let notifications = try medication.scheduleReminderNotifications(wasAdministered: false)

        // Then
        XCTAssertEqual(notifications.first?.triggerDate, try .factory(year: 2022, month: 1, day: 29, hour: 9, minute: 15, second: 0))
        for index in 0..<notifications.count {
            assertNotification(
                notifications[index],
                notificationId: "\(medication.id)_\(index)",
                medicationId: String(describing: medication.id),
                body: "Have you taken your \(medication.name) today?"
            )
        }
    }

    func test_scheduleReminderNotifications_wasAdministeredToday() throws {
        // Given
        let reminderTime = try ReminderTime(hour: 9, minute: 15)
        let medication = MedicationBuilder.aMedication()
            .withRemindersEnabled(at: reminderTime)
            .build()
        let now = try Date.factory(year: 2022, month: 1, day: 29, hour: 6, minute: 13, second: 34)
        Date.overrideCurrentDate(now)

        // When
        let notifications = try medication.scheduleReminderNotifications(wasAdministered: true)

        // Then
        XCTAssertEqual(notifications.first?.triggerDate, try .factory(year: 2022, month: 1, day: 30, hour: 9, minute: 15, second: 0))
        for index in 0..<notifications.count {
            assertNotification(
                notifications[index],
                notificationId: "\(medication.id)_\(index)",
                medicationId: String(describing: medication.id),
                body: "Have you taken your \(medication.name) today?"
            )
        }
    }

    // MARK: Helpers

    private func assertNotification(
        _ notif: ReminderNotification,
        notificationId: String,
        medicationId: String,
        body: String,
//        triggerDate: Date,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(notificationId, notif.id, file: file, line: line)
        XCTAssertEqual(medicationId, notif.medicationId, file: file, line: line)
        XCTAssertEqual(body, notif.body, file: file, line: line)
//        XCTAssertEqual(triggerDate, notif.triggerDate, file: file, line: line)
    }
}

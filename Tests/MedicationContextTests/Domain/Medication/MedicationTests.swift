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
        let medication = Medication(id: medicationId, name: name)
        XCTAssertEqual(medicationId, medication.id)
        XCTAssertEqual(name, medication.name)
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

    // MARK: scheduleReminderNotifications

    func test_scheduleReminderNotifications_() throws {
        let now = try Date.factory(year: 2022, month: 1, day: 29, hour: 6, minute: 13, second: 34)
        let reminderTime = try ReminderTime(hour: 9, minute: 15)
        Date.overrideCurrentDate(now)
        let medication = MedicationBuilder.aMedication()
            .withRemindersEnabled(at: reminderTime)
            .build()

        let notifications = try medication.scheduleReminderNotifications(wasAdministered: false)

        XCTAssertEqual(5, notifications.count)
        assertNotification(
            notifications[0],
            triggerDate: try .factory(year: 2022, month: 1, day: 29, hour: 9, minute: 15, second: 0),
            medication: medication,
            index: 0
        )
        assertNotification(
            notifications[1],
            triggerDate: try .factory(year: 2022, month: 1, day: 30, hour: 9, minute: 15, second: 0),
            medication: medication,
            index: 1
        )
        assertNotification(
            notifications[2],
            triggerDate: try .factory(year: 2022, month: 1, day: 31, hour: 9, minute: 15, second: 0),
            medication: medication,
            index: 2
        )
        assertNotification(
            notifications[3],
            triggerDate: try .factory(year: 2022, month: 2, day: 1, hour: 9, minute: 15, second: 0),
            medication: medication,
            index: 3
        )
        assertNotification(
            notifications[4],
            triggerDate: try .factory(year: 2022, month: 2, day: 2, hour: 9, minute: 15, second: 0),
            medication: medication,
            index: 4
        )
    }

    // MARK: Helpers

    private func assertNotification(
        _ notif: ReminderNotification,
        triggerDate: Date,
        medication: Medication,
        index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(triggerDate, notif.triggerDate, file: file, line: line)
        XCTAssertEqual("\(medication.id)_\(index)", notif.id, file: file, line: line)
        XCTAssertEqual(medication.id.description, notif.medicationId, file: file, line: line)
        XCTAssertEqual("Have you taken your \(medication.name) today?", notif.body, file: file, line: line)
    }

    private func assertTriggerDate(
        _ date: Date,
        year expectedYear: Int,
        month expectedMonth: Int,
        day expectedDay: Int,
        hour expectedHour: Int,
        minute expectedMinute: Int,
        calendar: Calendar = Calendar.current,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        XCTAssertEqual(expectedYear, year, file: file, line: line)
        XCTAssertEqual(expectedMonth, month, file: file, line: line)
        XCTAssertEqual(expectedDay, day, file: file, line: line)
        XCTAssertEqual(expectedHour, hour, file: file, line: line)
        XCTAssertEqual(expectedMinute, minute, file: file, line: line)
        XCTAssertEqual(00, second, file: file, line: line)
    }
}

import XCTest
@testable import MedicationContext
@testable import JFLib_Testing

class MedicationReminderTests: XCTestCase {
    let calendar = Calendar.current

    func test_scheduleNotifications_includingToday_beforeTriggerTime() throws {
        let medicationReminder = MedicationReminder(reminderTime: try .init(hour: 9, minute: 0))
        let startDate = try buildDate(year: 2022, month: 1, day: 23, hour: 8, minute: 23, second: 11)
        Date.overrideCurrentDate(startDate)

        let triggerDates = try medicationReminder.scheduleNotifications(includeToday: true)

        XCTAssertEqual(5, triggerDates.count)
        assertTriggerDate(triggerDates[0], year: 2022, month: 1, day: 23, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[1], year: 2022, month: 1, day: 24, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[2], year: 2022, month: 1, day: 25, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[3], year: 2022, month: 1, day: 26, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[4], year: 2022, month: 1, day: 27, hour: 9, minute: 00)
    }

    func test_scheduleNotifications_includingToday_afterTriggerTime() throws {
        let medicationReminder = MedicationReminder(reminderTime: try .init(hour: 9, minute: 0))
        let startDate = try buildDate(year: 2022, month: 1, day: 23, hour: 14, minute: 23, second: 11)
        Date.overrideCurrentDate(startDate)

        let triggerDates = try medicationReminder.scheduleNotifications(includeToday: true)

        XCTAssertEqual(5, triggerDates.count)
        assertTriggerDate(triggerDates[0], year: 2022, month: 1, day: 24, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[1], year: 2022, month: 1, day: 25, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[2], year: 2022, month: 1, day: 26, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[3], year: 2022, month: 1, day: 27, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[4], year: 2022, month: 1, day: 28, hour: 9, minute: 00)
    }

    func test_scheduleNotificationsNotIncludingToday() throws {
        let medicationReminder = MedicationReminder(reminderTime: try .init(hour: 9, minute: 0))
        let startDate = try buildDate(year: 2022, month: 1, day: 23, hour: 8, minute: 23, second: 11)
        Date.overrideCurrentDate(startDate)

        let triggerDates = try medicationReminder.scheduleNotifications(includeToday: false)

        XCTAssertEqual(5, triggerDates.count)
        assertTriggerDate(triggerDates[0], year: 2022, month: 1, day: 24, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[1], year: 2022, month: 1, day: 25, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[2], year: 2022, month: 1, day: 26, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[3], year: 2022, month: 1, day: 27, hour: 9, minute: 00)
        assertTriggerDate(triggerDates[4], year: 2022, month: 1, day: 28, hour: 9, minute: 00)
    }


    // MARK: - Helpers

    private func buildDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) throws -> Date {
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        return try XCTUnwrap(calendar.date(from: dateComponents))
    }

    private func assertTriggerDate(
        _ date: Date,
        year expectedYear: Int,
        month expectedMonth: Int,
        day expectedDay: Int,
        hour expectedHour: Int,
        minute expectedMinute: Int,
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

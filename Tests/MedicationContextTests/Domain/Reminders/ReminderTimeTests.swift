import XCTest
@testable import JFLib_Testing
@testable import MedicationContext

class ReminderTimeTests: XCTestCase {

    // MARK: - init(hour:minute:)

    func test_initWithHourAndMinute() throws {
        let sut = try ReminderTime(hour: 9, minute: 32)
        XCTAssertEqual(9, sut.hour)
        XCTAssertEqual(32, sut.minute)
    }

    func test_initWithHourAndMinute_hourTooHigh() throws {
        do {
            _ = try ReminderTime(hour: 24, minute: 0)
            XCTFail("No error was thrown")
        } catch ReminderTime.Errors.invalidHour {
            // Correct!
        }
    }

    func test_initWithHourAndMinute_hourTooLow() throws {
        do {
            _ = try ReminderTime(hour: -1, minute: 0)
            XCTFail("No error was thrown")
        } catch ReminderTime.Errors.invalidHour {
            // Correct!
        }
    }

    func test_initWithHourAndMinute_minuteTooHigh() throws {
        do {
            _ = try ReminderTime(hour: 0, minute: 60)
            XCTFail("No error was thrown")
        } catch ReminderTime.Errors.invalidMinute {
            // Correct!
        }
    }

    func test_initWithHourAndMinute_minuteTooLow() throws {
        do {
            _ = try ReminderTime(hour: 0, minute: -1)
            XCTFail("No error was thrown")
        } catch ReminderTime.Errors.invalidMinute {
            // Correct!
        }
    }

    // MARK: - canTriggerToday

    func test_canTriggerToday_() throws {
        let reminderTime = try ReminderTime(hour: 13, minute: 30)
        Date.overrideCurrentDate(self.date(hour: 12, minute: 0))
        XCTAssertTrue(reminderTime.canTriggerToday())
    }

    func test_canTriggerToday_2() throws {
        let reminderTime = try ReminderTime(hour: 13, minute: 30)
        Date.overrideCurrentDate(self.date(hour: 14, minute: 0))
        XCTAssertFalse(reminderTime.canTriggerToday())
    }

    func test_canTriggerToday_3() throws {
        let reminderTime = try ReminderTime(hour: 13, minute: 30)
        Date.overrideCurrentDate(self.date(hour: 13, minute: 15))
        XCTAssertTrue(reminderTime.canTriggerToday())
    }

    func test_canTriggerToday_4() throws {
        let reminderTime = try ReminderTime(hour: 13, minute: 30)
        Date.overrideCurrentDate(self.date(hour: 13, minute: 45))
        XCTAssertFalse(reminderTime.canTriggerToday())
    }

    func test_canTriggerToday_5() throws {
        let reminderTime = try ReminderTime(hour: 13, minute: 30)
        Date.overrideCurrentDate(self.date(hour: 14, minute: 15))
        XCTAssertFalse(reminderTime.canTriggerToday())
    }

    // MARK: - Helpers

    private func date(hour: Int, minute: Int) -> Date {
        Calendar.current.date(from: .init(hour: hour, minute: minute))!
    }
}

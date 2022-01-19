import XCTest
@testable import MedicationContext

class DateOnlyTests: XCTestCase {
    let calendar = Calendar.current

    // MARK: init(date:)

    func test_init_with_date() {
        let date = calendar.date(from: .init(year: 2021, month: 5, day: 17))!

        let dateOnly = DateOnly(date: date)

        XCTAssertEqual(2021, dateOnly.year)
        XCTAssertEqual(5, dateOnly.month)
        XCTAssertEqual(17, dateOnly.day)
    }
}

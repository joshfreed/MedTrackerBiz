import Foundation

struct DateOnly: Equatable, Hashable, Codable {
    let month: Int
    let day: Int
    let year: Int

    init(date: Date, calendar: Calendar = Calendar.current) {
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
    }

    func date(calendar: Calendar = Calendar.current) -> Date {
        calendar.date(from: .init(year: year, month: month, day: day))!
    }
}

extension Date {
    func dateOnly(calendar: Calendar = Calendar.current) -> DateOnly {
        DateOnly(date: self, calendar: calendar)
    }
}

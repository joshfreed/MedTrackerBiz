import Foundation

struct DateOnly: Equatable, Hashable, Codable {
    let month: Int
    let day: Int
    let year: Int

    init(month: Int, day: Int, year: Int) {
        self.month = month
        self.day = day
        self.year = year
    }

    init(date: Date, calendar: Calendar = Calendar.current) {
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        self.init(month: month, day: day, year: year)
    }
}

extension Date {
    func dateOnly() -> DateOnly {
        DateOnly(date: self)
    }
}

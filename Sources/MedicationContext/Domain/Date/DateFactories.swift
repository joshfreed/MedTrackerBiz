//
// Created by Josh Freed on 1/29/22.
//

import Foundation

extension Date {
    static func factory(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        calendar: Calendar = Calendar.current
    ) throws -> Date {
        let dateComponents = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        guard let date = calendar.date(from: dateComponents) else { throw DateError.invalidDate }
        return date
    }
}

enum DateError: Error {
    case invalidDate
}

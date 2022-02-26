import Foundation

extension Date {
    var hour: Int {
        Calendar.current.dateComponents([.hour], from: self).hour!
    }

    var minute: Int {
        Calendar.current.dateComponents([.minute], from: self).minute!
    }

    func tomorrow(calendar: Calendar = Calendar.current) -> Date {
        calendar.date(byAdding: .day, value: 1, to: self)!
    }
}
import Foundation

extension Int {
    var second: TimeInterval { TimeInterval(self) }
    var seconds: TimeInterval { TimeInterval(self) }
    var minute: TimeInterval { TimeInterval(self * 60) }
    var minutes: TimeInterval { TimeInterval(self * 60) }
    var hour: TimeInterval { TimeInterval(self * 3600) }
    var hours: TimeInterval { TimeInterval(self * 3600) }
    var day: TimeInterval { TimeInterval(self * 86400) }
    var days: TimeInterval { TimeInterval(self * 86400) }
}

import Foundation

public struct ReminderNotification: Codable {
    public let id: String
    public let medicationId: String
    public let body: String
    public let triggerDate: Date
}

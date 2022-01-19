import Foundation

final class MemoryDatabase {
    static let shared = MemoryDatabase()

    var medications: [Medication] = []
    var administrations: [Administration] = []

    private init() {}
}

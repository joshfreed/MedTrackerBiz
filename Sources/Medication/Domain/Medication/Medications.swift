import Foundation

protocol Medications {
    func getAll() async throws -> [Medication]
}

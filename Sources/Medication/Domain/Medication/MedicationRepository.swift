import Foundation

public protocol MedicationRepository {
    func getAll() async throws -> [Medication]
}

import Foundation

public protocol MedicationRepository {
    func add(_ medication: Medication) async throws
    func getAll() async throws -> [Medication]
    func getById(_ id: MedicationId) async throws -> Medication?
    func save() async throws
}

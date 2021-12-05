import Foundation

public protocol AdministrationRepository {
    func add(_ administration: Administration) async throws
    func findBy(medicationId: MedicationId, and date: Date) async throws -> Administration?
    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool
    func remove(_ administration: Administration) async throws
    func save() async throws
}

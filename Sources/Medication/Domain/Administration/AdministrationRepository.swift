import Foundation

public protocol AdministrationRepository {
    func add(_ administration: Administration) async throws
    func save() async throws
    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool
}

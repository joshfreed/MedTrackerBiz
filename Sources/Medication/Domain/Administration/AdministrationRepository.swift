import Foundation

public protocol AdministrationRepository {
    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool
}

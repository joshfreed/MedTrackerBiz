import Foundation

public class MemoryAdministrations: AdministrationRepository {
    public init() {}

    public func add(_ administration: Administration) async throws {
        MemoryDatabase.shared.administrations.append(administration)
    }

    public func findBy(medicationId: MedicationId, and date: Date) async throws -> Administration? {
        MemoryDatabase.shared.administrations.first { $0.medicationId == medicationId }
    }

    public func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        MemoryDatabase.shared.administrations.contains { $0.medicationId == medicationId }
    }

    public func remove(_ administration: Administration) async throws {
        fatalError("Not implemented")
    }

    public func save() async throws {}
}

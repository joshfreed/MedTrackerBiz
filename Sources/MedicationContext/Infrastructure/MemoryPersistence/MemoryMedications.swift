import Foundation

public class MemoryMedications: MedicationRepository {
    public init() {}

    public func add(_ medication: Medication) async throws {
        MemoryDatabase.shared.medications.append(medication)
    }

    public func getAll() async throws -> [Medication] {
        MemoryDatabase.shared.medications
    }

    public func getById(_ id: MedicationId) async throws -> Medication? {
        MemoryDatabase.shared.medications.first { $0.id == id }
    }

    public func save() async throws {}

    public func update(_ medication: Medication) {}
}

import Foundation

class FindMedicationByName {
    private let medications: MedicationRepository

    init(medications: MedicationRepository) {
        self.medications = medications
    }

    func findOne(named name: String) async throws -> Medication? {
        let allMedications = try await medications.getAll()
        let lowercaseName = name.lowercased()
        return allMedications.first { $0.name.lowercased() == lowercaseName }
    }
}

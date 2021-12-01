import Foundation
@testable import MedicationApp

class MockMedications: MedicationRepository {
    var medications: [Medication] = []

    func getAll() async throws -> [Medication] {
        medications
    }
}

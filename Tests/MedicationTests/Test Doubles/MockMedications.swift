import Foundation
@testable import MedicationApp

class MockMedications: MedicationRepository {

    // MARK: getAll

    var getAllResult: [Medication] = []

    func configure_getAll_toReturn(_ medications: [Medication]) {
        getAllResult = medications
    }

    func getAll() async throws -> [Medication] {
        getAllResult
    }
}

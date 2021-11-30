import Foundation
@testable import Medication

class MockMedications: Medications {
    var medications: [Medication] = []

    func getAll() async throws -> [Medication] {
        medications
    }
}

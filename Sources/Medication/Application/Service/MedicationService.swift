import Foundation

class MedicationService: GetDailyScheduleUseCase {
    private let medications: Medications

    init(medications: Medications) {
        self.medications = medications
    }

    func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
        let medications = try await medications.getAll()

        let responseMedications: [GetTrackedMedicationsResponse.Medication] = medications.map {
            .init(id: String(describing: $0.id), name: $0.name, administrations: [])
        }

        return GetTrackedMedicationsResponse(medications: responseMedications)
    }
}

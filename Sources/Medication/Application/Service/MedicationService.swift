import Foundation

public class MedicationService: GetTrackedMedicationsUseCase {
    private let medications: MedicationRepository

    public init(medications: MedicationRepository) {
        self.medications = medications
    }

    public func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
        let medications = try await medications.getAll()

        let responseMedications: [GetTrackedMedicationsResponse.Medication] = medications.map {
            .init(id: String(describing: $0.id), name: $0.name, wasAdministered: false)
        }

        return GetTrackedMedicationsResponse(medications: responseMedications)
    }
}

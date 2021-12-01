import Foundation

public class MedicationService: GetTrackedMedicationsUseCase {
    private let medications: MedicationRepository
    private let administrations: AdministrationRepository

    public init(medications: MedicationRepository, administrations: AdministrationRepository) {
        self.medications = medications
        self.administrations = administrations
    }

    public func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
        let medications = try await medications.getAll()
        let responseMedications = try await map(models: medications, date: query.date)
        return GetTrackedMedicationsResponse(medications: responseMedications)
    }

    private func map(models: [Medication], date: Date) async throws -> [GetTrackedMedicationsResponse.Medication] {
        var result: [GetTrackedMedicationsResponse.Medication] = []
        for model in models {
            let mapped = try await mapMedication(from: model, on: date)
            result.append(mapped)
        }
        return result
    }

    private func mapMedication(from model: Medication, on date: Date) async throws -> GetTrackedMedicationsResponse.Medication {
        let id = String(describing: model.id)
        let wasAdministered = try await administrations.hasAdministration(on: date, for: model.id)
        return .init(id: id, name: model.name, wasAdministered: wasAdministered)
    }
}

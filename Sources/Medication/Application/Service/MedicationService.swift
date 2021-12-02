import Foundation

public class MedicationService {
    private let medications: MedicationRepository
    private let administrations: AdministrationRepository

    public init(medications: MedicationRepository, administrations: AdministrationRepository) {
        self.medications = medications
        self.administrations = administrations
    }
}

extension MedicationService: TrackMedicationUseCase {
    public func handle(_ command: TrackMedicationCommand) async throws {
        let medication = Medication(name: command.name)
        try await medications.add(medication)
        try await medications.save()
    }
}

extension MedicationService: GetTrackedMedicationsUseCase {
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

extension MedicationService: RecordAdministrationUseCase {
    public func handle(_ command: RecordAdministrationCommand) async throws {
        guard let medicationId = MedicationId(uuidString: command.medicationId) else {
            throw RecordAdministrationError.invalidMedicationId
        }

        guard try await medications.getById(medicationId) != nil else {
            throw RecordAdministrationError.medicationNotFound
        }

        let administration = Administration(medicationId: medicationId)

        try await administrations.add(administration)
        try await administrations.save()
    }
}

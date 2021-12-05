import Foundation
import Combine

public class MedicationService {
    private let medications: MedicationRepository
    private let administrations: AdministrationRepository
    private var getTrackedMedicationsSubject = CurrentValueSubject<GetTrackedMedicationsResponse?, Error>(nil)

    public init(medications: MedicationRepository, administrations: AdministrationRepository) {
        self.medications = medications
        self.administrations = administrations
    }

    private func publishCurrentValue(of query: GetTrackedMedicationsQuery) {
        Task {
            do {
                let response = try await handle(query)
                getTrackedMedicationsSubject.send(response)
            } catch {
                getTrackedMedicationsSubject.send(completion: .failure(error))
            }
        }
    }
}

// MARK: - TrackMedicationUseCase

extension MedicationService: TrackMedicationUseCase {
    public func handle(_ command: TrackMedicationCommand) async throws {
        let medication = Medication(name: command.name)
        try await medications.add(medication)
        try await medications.save()
        publishCurrentValue(of: GetTrackedMedicationsQuery(date: Date.current))
    }
}

// MARK: - GetTrackedMedicationsContinuousQuery

extension MedicationService: GetTrackedMedicationsContinuousQuery {
    public func subscribe(_ query: GetTrackedMedicationsQuery) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        if getTrackedMedicationsSubject.value == nil {
            publishCurrentValue(of: query)
        }

        return getTrackedMedicationsSubject.compactMap { $0 }.eraseToAnyPublisher()
    }
}

// MARK: - GetTrackedMedicationsUseCase

extension MedicationService: GetTrackedMedicationsUseCase {
    public func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
        let medications = try await medications.getAll()
        let responseMedications = try await map(models: medications, date: query.date)
        return GetTrackedMedicationsResponse(date: query.date, medications: responseMedications)
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

// MARK: - RecordAdministrationUseCase

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

        publishCurrentValue(of: GetTrackedMedicationsQuery(date: Date.current))
    }
}

// MARK: - RemoveAdministrationUseCase

extension MedicationService: RemoveAdministrationUseCase {
    public func handle(_ command: RemoveAdministrationCommand) async throws {
        guard let medicationId = MedicationId(uuidString: command.medicationId) else {
            throw RemoveAdministrationError.invalidMedicationId
        }

        guard try await medications.getById(medicationId) != nil else {
            throw RemoveAdministrationError.medicationNotFound
        }

        guard let administration = try await administrations.findBy(medicationId: medicationId, and: Date.current) else {
            throw RemoveAdministrationError.administrationNotFound
        }

        try await administrations.remove(administration)
        try await administrations.save()

        publishCurrentValue(of: GetTrackedMedicationsQuery(date: Date.current))
    }
}

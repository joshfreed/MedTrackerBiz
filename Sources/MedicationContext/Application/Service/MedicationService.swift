import Foundation
import Combine
import JFLib_DomainEvents
import MTBackEndCore
import OSLog

public class MedicationService {
    private let medications: MedicationRepository
    private let administrations: AdministrationRepository
    private let logger: Logger
    private var getTrackedMedicationsSubjects: [DateOnly: CurrentValueSubject<GetTrackedMedicationsResponse?, Error>] = [:]

    public init(
        medications: MedicationRepository,
        administrations: AdministrationRepository,
        logger: Logger
    ) {
        self.medications = medications
        self.administrations = administrations
        self.logger = logger
    }

    /// Publishes the current value of all `GetTrackedMedicationsContinuousQuery` that have been subscribed
    public func refreshContinuousQueries() {
        getTrackedMedicationsSubjects.keys.forEach { dateOnly in
            let date = dateOnly.date()
            publishCurrentValue(of: .init(date: date))
        }
    }

    private func publishCurrentValue(of query: GetTrackedMedicationsQuery) {
        let subject = getTrackedMedicationsSubjects[query.date.dateOnly()]
        Task {
            do {
                let response = try await handle(query)
                subject?.send(response)
            } catch {
                subject?.send(completion: .failure(error))
            }
        }
    }
}

// MARK: - Errors

enum MedicationServiceErrors: Error {
    case invalidMedicationId
    case medicationNotFound
}

// MARK: - TrackMedication

extension MedicationService {
    public func handle(_ command: TrackMedicationCommand) async throws {
        DomainEventPublisher.shared.subscribe(DomainEventSubscriber<NewMedicationTracked> { domainEvent in
            self.publishCurrentValue(of: GetTrackedMedicationsQuery(date: Date.current))
        })

        var medication = Medication(name: command.name)
        DomainEvents.add(NewMedicationTracked(
            id: String(describing: medication.id),
            name: medication.name
        ))

        let reminderTime = try ReminderTime(hour: 9, minute: 0)
        medication.enableReminderNotifications(at: reminderTime)

        try await medications.add(medication)
        try await medications.save()

        DomainEventPublisher.shared.publishPendingEvents()
    }
}

// MARK: - GetTrackedMedications

extension MedicationService {
    public func subscribe(_ query: GetTrackedMedicationsQuery) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        var subject: CurrentValueSubject<GetTrackedMedicationsResponse?, Error>

        if let existingSubject = getTrackedMedicationsSubjects[query.date.dateOnly()] {
            subject = existingSubject
        } else {
            subject = CurrentValueSubject<GetTrackedMedicationsResponse?, Error>(nil)
            getTrackedMedicationsSubjects[query.date.dateOnly()] = subject
            publishCurrentValue(of: query)
        }

        return subject.compactMap { $0 }.eraseToAnyPublisher()
    }

    public func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
        logger.debug("Handling GetTrackedMedicationsQuery \(query.date)")
        let medications = try await medications.getAll()
        logger.debug("Got all medications")
        let responseMedications = try await map(models: medications, date: query.date)
        logger.debug("Mapped medications to response")
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

// MARK: - RecordAdministration

extension MedicationService {
    public func handle(_ command: RecordAdministrationCommand) async throws {
        guard let medicationId = MedicationId(uuidString: command.medicationId) else {
            throw RecordAdministrationError.invalidMedicationId
        }

        guard let medication = try await medications.getById(medicationId) else {
            throw RecordAdministrationError.medicationNotFound
        }

        try await recordAdministration(medication: medication, administrationDate: Date.current)
    }

    public func handle(_ command: RecordAdministrationByNameCommand) async throws {
        let medicationQuery = FindMedicationByName(medications: medications)

        guard let medication = try await medicationQuery.findOne(named: command.medicationName) else {
            throw RecordAdministrationError.medicationNotFound
        }

        try await recordAdministration(medication: medication, administrationDate: Date.current)
    }

    private func recordAdministration(medication: Medication, administrationDate: Date) async throws {
        DomainEventPublisher.shared.subscribe(DomainEventSubscriber<AdministrationRecorded> { domainEvent in
            self.publishCurrentValue(of: GetTrackedMedicationsQuery(date: Date.current))
        })

        let hasAdministration = try await administrations.hasAdministration(on: administrationDate, for: medication.id)
        guard !hasAdministration else {
            throw RecordAdministrationError.administrationAlreadyRecorded
        }

        let administration = medication.recordAdministration(on: administrationDate)

        try await administrations.add(administration)
        try await administrations.save()

        DomainEventPublisher.shared.publishPendingEvents()
    }
}

// MARK: - RemoveAdministration

extension MedicationService {
    public func handle(_ command: RemoveAdministrationCommand) async throws {
        DomainEventPublisher.shared.subscribe(DomainEventSubscriber<AdministrationRemoved> { domainEvent in
            self.publishCurrentValue(of: GetTrackedMedicationsQuery(date: Date.current))
        })

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

        DomainEvents.add(AdministrationRemoved(
            administrationId: String(describing: administration.id),
            medicationId: String(describing: command.medicationId)
        ))

        DomainEventPublisher.shared.publishPendingEvents()
    }
}

// MARK: - GetEditableMedication

extension MedicationService {
    public func handle(_ query: GetEditableMedicationQuery) async throws -> GetEditableMedicationResponse {
        guard let medicationId = MedicationId(uuidString: query.medicationId) else {
            throw MedicationServiceErrors.invalidMedicationId
        }

        guard let medication = try await medications.getById(medicationId) else {
            throw MedicationServiceErrors.medicationNotFound
        }

        let response = GetEditableMedicationResponse(
            name: medication.name,
            reminderTime: medication.reminder?.reminderTime.toDate()
        )

        return response
    }
}

// MARK: - UpdateMedication

extension MedicationService {
    public func handle(_ command: UpdateMedicationCommand) async throws {
        guard let medicationId = MedicationId(uuidString: command.medicationId) else {
            throw MedicationServiceErrors.invalidMedicationId
        }

        guard var medication = try await medications.getById(medicationId) else {
            throw MedicationServiceErrors.medicationNotFound
        }

        if let reminderTime = command.reminderTime {
            medication.enableReminderNotifications(at: .init(date: reminderTime))
        } else {
            medication.disableReminderNotifications()
        }

        try await medications.update(medication)
        try await medications.save()

        DomainEvents.add(MedicationUpdated(id: command.medicationId))
        DomainEventPublisher.shared.publishPendingEvents()
    }
}

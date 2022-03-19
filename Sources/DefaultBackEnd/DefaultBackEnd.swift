import Foundation
import Combine
import MTBackEndCore
import MedicationContext

class DefaultBackEnd: MedTrackerBackEnd {
    private let trackMedication: TrackMedicationUseCase
    private let getTrackedMedicationsQuery: GetTrackedMedicationsContinuousQuery
    private let getTrackedMedicationsUseCase: GetTrackedMedicationsUseCase
    private let recordAdministrationUseCase: RecordAdministrationUseCase
    private let removeAdministrationUseCase: RemoveAdministrationUseCase
    private let scheduleRemindersUseCase: ScheduleReminderNotificationsUseCase

    init(
        trackMedication: TrackMedicationUseCase,
        getTrackedMedicationsQuery: GetTrackedMedicationsContinuousQuery,
        getTrackedMedications: GetTrackedMedicationsUseCase,
        recordAdministration: RecordAdministrationUseCase,
        removeAdministration: RemoveAdministrationUseCase,
        scheduleRemindersUseCase: ScheduleReminderNotificationsUseCase
    ) {
        self.trackMedication = trackMedication
        self.getTrackedMedicationsQuery = getTrackedMedicationsQuery
        self.getTrackedMedicationsUseCase = getTrackedMedications
        self.recordAdministrationUseCase = recordAdministration
        self.removeAdministrationUseCase = removeAdministration
        self.scheduleRemindersUseCase = scheduleRemindersUseCase
    }

    func trackMedication(name: String, administrationTime: Int) async throws {
        let command = TrackMedicationCommand(name: name, administrationTime: 9)
        try await trackMedication.handle(command)
    }

    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        getTrackedMedicationsQuery.subscribe(.init(date: date))
    }

    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse {
        try await getTrackedMedicationsUseCase.handle(.init(date: date))
    }

    func recordAdministration(medicationId: String) async throws {
        try await recordAdministrationUseCase.handle(RecordAdministrationCommand(medicationId: medicationId))
    }

    func recordAdministration(medicationName: String) async throws {
        try await recordAdministrationUseCase.handle(RecordAdministrationByNameCommand(medicationName: medicationName))
    }

    func removeAdministration(medicationId: String) async throws {
        try await removeAdministrationUseCase.handle(RemoveAdministrationCommand(medicationId: medicationId))
    }

    func scheduleReminderNotifications() async throws {
        try await scheduleRemindersUseCase.handle(.init())
    }
}

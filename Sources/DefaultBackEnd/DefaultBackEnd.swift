import Foundation
import Combine
import MTBackEndCore
import MedicationContext
import JFLib_Services

class DefaultBackEnd: MedTrackerBackEnd {
    @Injected private var medicationService: MedicationService
    @Injected private var remindersService: RemindersService

    func trackMedication(name: String, administrationTime: Int) async throws {
        let command = TrackMedicationCommand(name: name, administrationTime: 9)
        try await medicationService.handle(command)
    }

    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        medicationService.subscribe(.init(date: date))
    }

    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse {
        try await medicationService.handle(.init(date: date))
    }

    func recordAdministration(medicationId: String) async throws {
        try await medicationService.handle(RecordAdministrationCommand(medicationId: medicationId))
    }

    func recordAdministration(medicationName: String) async throws {
        try await medicationService.handle(RecordAdministrationByNameCommand(medicationName: medicationName))
    }

    func removeAdministration(medicationId: String) async throws {
        try await medicationService.handle(RemoveAdministrationCommand(medicationId: medicationId))
    }

    func scheduleReminderNotifications() async throws {
        try await remindersService.handle(.init())
    }
}

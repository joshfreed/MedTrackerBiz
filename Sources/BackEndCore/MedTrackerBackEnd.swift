import Foundation
import Combine

public protocol MedTrackerBackEnd {
    // MARK: Queries
    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error>
    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse
    func getEditableMedication(by id: String) async throws -> GetEditableMedicationResponse

    // MARK: Business Actions
    func trackMedication(name: String, administrationTime: Int) async throws
    func recordAdministration(medicationId: String) async throws
    func recordAdministration(medicationName: String) async throws
    func removeAdministration(medicationId: String) async throws
    func scheduleReminderNotifications() async throws
    func updateMedication(_ command: UpdateMedicationCommand) async throws
}

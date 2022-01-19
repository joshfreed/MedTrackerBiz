import Foundation
import Combine
import MedicationContext

public protocol MedTrackerBackEnd {
    // MARK: Queries
    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error>
    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse

    // MARK: Business Actions
    func trackMedication(name: String, administrationTime: Int) async throws
    func recordAdministration(medicationId: String) async throws
    func recordAdministration(medicationName: String) async throws
    func removeAdministration(medicationId: String) async throws
}

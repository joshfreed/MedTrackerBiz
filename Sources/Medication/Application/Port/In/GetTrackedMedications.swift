import Foundation
import Combine

public struct GetTrackedMedicationsQuery {
    public let date: Date

    public init(date: Date = Date()) {
        self.date = date
    }
}

public struct GetTrackedMedicationsResponse {
    public let date: Date
    public let medications: [Medication]

    public init(date: Date, medications: [Medication]) {
        self.date = date
        self.medications = medications
    }

    public struct Medication {
        public let id: String
        public let name: String
        public let wasAdministered: Bool

        public init(id: String, name: String, wasAdministered: Bool = false) {
            self.id = id
            self.name = name
            self.wasAdministered = wasAdministered
        }
    }
}

public protocol GetTrackedMedicationsUseCase {
    func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse
}

public protocol GetTrackedMedicationsContinuousQuery {
    func subscribe(_ query: GetTrackedMedicationsQuery) -> AnyPublisher<GetTrackedMedicationsResponse, Error>
}

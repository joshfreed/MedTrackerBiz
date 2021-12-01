import Foundation

public struct GetTrackedMedicationsQuery {
    public init() {}
}

public struct GetTrackedMedicationsResponse {
    public let medications: [Medication]

    public init(medications: [Medication]) {
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

import Foundation

public struct GetTrackedMedicationsQuery {
    public let date: Date

    public init(date: Date = Date()) {
        self.date = date
    }
}

public struct GetTrackedMedicationsResponse: Equatable {
    public let date: Date
    public let medications: [Medication]

    public init(date: Date, medications: [Medication]) {
        self.date = date
        self.medications = medications
    }

    public struct Medication: Equatable {
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

//
//  GetTrackedMedications.swift
//  
//
//  Created by Josh Freed on 11/28/21.
//

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
        public let administrations: [Administration]

        public init(id: String, name: String, administrations: [Administration] = []) {
            self.id = id
            self.name = name
            self.administrations = administrations
        }
    }

    public struct Administration {
        internal init(description: String) {
            self.description = description
        }

        public let description: String
    }
}

public protocol GetDailyScheduleUseCase {
    func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse
}

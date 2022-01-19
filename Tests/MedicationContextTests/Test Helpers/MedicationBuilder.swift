import Foundation
@testable import MedicationContext

class MedicationBuilder {
    private var id = MedicationId()
    private var name = "Random Name"
    private var administrationTime = 9

    static func aMedication() -> MedicationBuilder {
        MedicationBuilder()
    }

    func build() -> Medication {
        let medication = try! Medication(id: id, name: name, administrationTime: administrationTime)
        return medication
    }

    func with(id: MedicationId) -> MedicationBuilder {
        self.id = id
        return self
    }

    func with(name: String) -> MedicationBuilder {
        self.name = name
        return self
    }

    func administeredAt(hour: Int) -> MedicationBuilder {
        administrationTime = hour
        return self
    }
}

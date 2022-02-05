import Foundation
@testable import MedicationContext

class MedicationBuilder {
    private var id = MedicationId()
    private var name = "Random Name"

    static func aMedication() -> MedicationBuilder {
        MedicationBuilder()
    }

    func build() -> Medication {
        var medication = Medication(id: id, name: name)
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

    
}

import Foundation

struct Medication: Equatable, Codable {
    let id: MedicationId
    private(set) var name: String

    init(name: String) {
        self.id = MedicationId()
        self.name = name
    }

    init(id: MedicationId, name: String) {
        self.id = id
        self.name = name
    }

    static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.id == rhs.id
    }
}

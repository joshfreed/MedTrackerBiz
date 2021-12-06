import Foundation
import JFLib_DomainEvents

public struct Medication: Equatable, Codable {
    public let id: MedicationId
    public private(set) var name: String

    public init(name: String) {
        self.id = MedicationId()
        self.name = name
    }

    init(id: MedicationId, name: String) {
        self.id = id
        self.name = name
    }

    public static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.id == rhs.id
    }

    func recordAdministration(on date: Date) -> Administration {
        let administration = Administration(medicationId: id)
        DomainEvents.add(AdministrationRecorded(
            id: administration.id,
            medicationId: id,
            administrationDate: administration.administrationDate
        ))
        return administration
    }
}

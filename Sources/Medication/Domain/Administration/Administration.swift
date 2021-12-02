import Foundation

public class Administration: Equatable {
    public let id: AdministrationId
    public let medicationId: MedicationId

    internal init(id: AdministrationId, medicationId: MedicationId) {
        self.id = id
        self.medicationId = medicationId
    }

    internal init(medicationId: MedicationId) {
        self.id = AdministrationId()
        self.medicationId = medicationId
    }

    public static func ==(lhs: Administration, rhs: Administration) -> Bool {
        lhs.id == rhs.id && lhs.medicationId == rhs.medicationId
    }
}

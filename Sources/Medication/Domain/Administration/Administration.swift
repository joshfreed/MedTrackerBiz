import Foundation
import JFLib_Date

public class Administration: Equatable {
    public let id: AdministrationId
    public let medicationId: MedicationId
    public let administrationDate: Date

    internal init(id: AdministrationId, medicationId: MedicationId) {
        self.id = id
        self.medicationId = medicationId
        self.administrationDate = Date.current
    }

    internal init(medicationId: MedicationId) {
        self.id = AdministrationId()
        self.medicationId = medicationId
        self.administrationDate = Date.current
    }

    public static func ==(lhs: Administration, rhs: Administration) -> Bool {
        lhs.id == rhs.id && lhs.medicationId == rhs.medicationId
    }
}

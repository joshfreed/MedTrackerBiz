import Foundation

public class Administration {
    public let id: AdministrationId
    public let medicationId: MedicationId

    public init(medicationId: MedicationId) {
        self.id = AdministrationId()
        self.medicationId = medicationId
    }
}

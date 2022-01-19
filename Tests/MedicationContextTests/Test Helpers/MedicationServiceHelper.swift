import Foundation
@testable import MedicationContext

extension MedicationService {
    static func factory(
        medications: MedicationRepository = MockMedications(),
        administrations: AdministrationRepository = MockAdministrations()
    ) -> MedicationService {
        MedicationService(
            medications: medications,
            administrations: administrations
        )
    }
}

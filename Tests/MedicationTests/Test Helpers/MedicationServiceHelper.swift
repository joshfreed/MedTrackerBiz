import Foundation
@testable import MedicationApp

extension MedicationService {
    static func factory(
        medications: MedicationRepository = MockMedications(),
        administrations: AdministrationRepository = MockAdministrations(),
        shortcutDonation: ShortcutDonationService = MockDonationService()
    ) -> MedicationService {
        MedicationService(medications: medications, administrations: administrations, shortcutDonation: shortcutDonation)
    }
}

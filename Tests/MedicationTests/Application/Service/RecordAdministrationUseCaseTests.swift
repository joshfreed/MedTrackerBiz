import XCTest
@testable import JFLib_Testing
@testable import MedicationApp

class RecordAdministrationUseCaseTests: XCTestCase {
    var sut: RecordAdministrationUseCase!
    let administrations = MockAdministrations()
    let medications = MockMedications()
    let donationService = MockDonationService()
    let today = Date()

    override func setUpWithError() throws {
        Date.overrideCurrentDate(self.today)

        sut = MedicationService.factory(
            medications: medications,
            administrations: administrations,
            shortcutDonation: donationService
        )
    }

    func test_adds_new_administration_record_to_repository() async throws {
        // Given
        let medicationId = MedicationId()
        let medication = Medication(id: medicationId, name: "My Medication")
        medications.configure_getById_toReturn(medication, forId: medicationId)

        // When
        try await sut.handle(RecordAdministrationCommand(medicationId: String(describing: medicationId)))

        // Then
        administrations.verify_add_wasCalled(withAdministrationFor: medicationId)
        administrations.verify_save_wasCalled()
    }

    func test_invalid_medication_id_throws_error() async {
        let medicationIdString = "ZZ2345FFF_not_a_uuid"

        do {
            try await sut.handle(RecordAdministrationCommand(medicationId: medicationIdString))
            XCTFail("Expected an error to be thrown")
        } catch RecordAdministrationError.invalidMedicationId {
            // Yay
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func test_no_matching_medication_throws_notFound_error() async {
        let medicationId = MedicationId()

        do {
            try await sut.handle(RecordAdministrationCommand(medicationId: String(describing: medicationId)))
            XCTFail("Expected an error to be thrown")
        } catch RecordAdministrationError.medicationNotFound {
            // Yay!
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func test_donates_shortcut_on_success() async throws {
        // Given
        let medicationId = MedicationId()
        let medication = Medication(id: medicationId, name: "My Medication")
        medications.configure_getById_toReturn(medication, forId: medicationId)

        // When
        try await sut.handle(RecordAdministrationCommand(medicationId: String(describing: medicationId)))

        // Then
        let administrationId = administrations.added!.id
        let expectedEvent = AdministrationRecorded(
            id: administrationId,
            medicationId: medicationId,
            administrationDate: Date.current,
            medicationName: medication.name
        )
        donationService.verify_donateInteraction_wasCalled()
        XCTAssertEqual(donationService.donatedDomainEvent as? AdministrationRecorded, expectedEvent)
    }

    func test_throws_an_error_if_an_administration_was_already_recorded_for_the_medication_today() async throws {
        // Given
        let medicationId = MedicationId()
        let medication = Medication(id: medicationId, name: "My Medication")
        medications.configure_getById_toReturn(medication, forId: medicationId)
        administrations.configure_hasAdministration_toReturn(true, on: Date.current, for: medicationId)

        do {
            try await sut.handle(RecordAdministrationCommand(medicationId: String(describing: medicationId)))
            XCTFail("Expected an error to be thrown")
        } catch RecordAdministrationError.administrationAlreadyRecorded {
            // Yay!
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }
}

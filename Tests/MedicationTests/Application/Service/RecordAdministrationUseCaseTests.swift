import XCTest
@testable import MedicationApp

class RecordAdministrationUseCaseTests: XCTestCase {
    var sut: RecordAdministrationUseCase!
    let administrations = MockAdministrations()
    let medications = MockMedications()

    override func setUpWithError() throws {
        sut = MedicationService(medications: medications, administrations: administrations)
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

    func test_invalid_medication_id_throws_badRequest() async {
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
}

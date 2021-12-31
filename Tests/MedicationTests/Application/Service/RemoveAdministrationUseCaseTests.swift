import XCTest
import Combine
@testable import MedicationApp
@testable import JFLib_Testing

class RemoveAdministrationUseCaseTests: XCTestCase {
    var sut: MedicationService!
    let administrations = MockAdministrations()
    let medications = MockMedications()
    let currentDate = Date()
    var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        sut = MedicationService.factory(medications: medications, administrations: administrations)

        Date.overrideCurrentDate(self.currentDate)
    }

    override func tearDownWithError() throws {
        Date.overrideCurrentDate(Date())
    }

    func test_invalid_medication_id_throws_error() async {
        let medicationIdString = "ZZ2345FFF_not_a_uuid"

        do {
            try await sut.handle(RemoveAdministrationCommand(medicationId: medicationIdString))
            XCTFail("Expected an error to be thrown")
        } catch RemoveAdministrationError.invalidMedicationId {
            // Yay
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func test_no_matching_medication_throws_notFound_error() async {
        let medicationId = MedicationId()

        do {
            try await sut.handle(RemoveAdministrationCommand(medicationId: String(describing: medicationId)))
            XCTFail("Expected an error to be thrown")
        } catch RemoveAdministrationError.medicationNotFound {
            // Yay!
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func test_no_matching_administration_throws_notFound_error() async throws {
        let medication = MedicationBuilder.aMedication().build()
        medications.configure_getById_toReturn(medication, forId: medication.id)

        do {
            try await sut.handle(RemoveAdministrationCommand(medicationId: String(describing: medication.id)))
            XCTFail("Expected an error to be thrown")
        } catch RemoveAdministrationError.administrationNotFound {
            // Yay!
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }

    func test_deletes_administration_record_matching_medicationId_and_date() async throws {
        // Given
        let medicationId = MedicationId()
        let medication = MedicationBuilder.aMedication()
            .with(id: medicationId)
            .build()
        medications.configure_getById_toReturn(medication, forId: medicationId)
        let administration = Administration(medicationId: medicationId)
        administrations.configure_findByMedicationAndDate_toReturn(administration, for: medicationId, and: currentDate)

        // When
        try await sut.handle(RemoveAdministrationCommand(medicationId: String(describing: medicationId)))

        // Then
        administrations.verify_remove_wasCalled(with: administration)
        administrations.verify_save_wasCalled()
    }

    func test_removeAdministrationUseCase_publishes_an_updates_to_query() async throws {
        // Given
        let medicationId = MedicationId()
        let medication = MedicationBuilder.aMedication()
            .with(id: medicationId)
            .build()
        medications.configure_getAll_toReturn([medication])
        medications.configure_getById_toReturn(medication, forId: medicationId)
        let administration = Administration(medicationId: medicationId)
        administrations.configure_findByMedicationAndDate_toReturn(administration, for: medicationId, and: currentDate)
        expectQueryToPublishNewValue()

        // When
        try await sut.handle(RemoveAdministrationCommand(medicationId: String(describing: medicationId)))

        // Then
        await waitForExpectations(timeout: 5)
    }

    // MARK: - Helpers

    private func expectQueryToPublishNewValue() {
        let expectation = expectation(description: "Published updated query")

        cancellable = sut.subscribe(.init(date: currentDate))
            .dropFirst() // ignores the initial fetch that happens on subscribe
            .sink { completion in
                XCTFail("Should not complete")
            } receiveValue: { response in
                expectation.fulfill()
            }
    }
}

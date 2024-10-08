import XCTest
import MTBackEndCore
@testable import MedicationContext

class GetTrackedMedicationsUseCaseTests: XCTestCase {
    var sut: MedicationService!
    let medications = MockMedications()
    let administrations = MockAdministrations()

    override func setUpWithError() throws {
        continueAfterFailure = false
        sut = MedicationService.factory(medications: medications, administrations: administrations)
    }

    func test_no_medications_returns_an_empty_list() async throws {
        medications.configure_getAll_toReturn([])

        let response = try await sut.handle(GetTrackedMedicationsQuery())

        XCTAssertEqual(0, response.medications.count)
    }

    func test_returns_single_medication_not_administered_today() async throws {
        medications.configure_getAll_toReturn([
            MedicationBuilder.aMedication().with(name: "Test Med 1").build()
        ])

        let response = try await sut.handle(GetTrackedMedicationsQuery())

        XCTAssertEqual(1, response.medications.count)
        XCTAssertEqual("Test Med 1", response.medications[0].name)
        XCTAssertFalse(response.medications[0].wasAdministered)
    }

    func test_returns_single_medication_that_was_administered_today() async throws {
        // Given
        let today = Date()
        let med = MedicationBuilder.aMedication().with(name: "Testaprexin").build()
        medications.configure_getAll_toReturn([med])
        administrations.configure_hasAdministration_toReturn(true, on: today, for: med.id)

        // When
        let response = try await sut.handle(GetTrackedMedicationsQuery(date: today))

        // Then
        XCTAssertTrue(response.medications[0].wasAdministered)
    }

    func test_returns_multiple_medications_and_their_administration_states() async throws {
        // Given
        let today = Date()
        let med1 = MedicationBuilder.aMedication().with(name: "Testaprexin").build()
        let med2 = MedicationBuilder.aMedication().with(name: "Allegra").build()
        let med3 = MedicationBuilder.aMedication().with(name: "Beezlepill").build()
        medications.configure_getAll_toReturn([med1, med2, med3])
        administrations.configure_hasAdministration_toReturn(true, on: today, for: med1.id)
        administrations.configure_hasAdministration_toReturn(false, on: today, for: med2.id)
        administrations.configure_hasAdministration_toReturn(true, on: today, for: med3.id)

        // When
        let response = try await sut.handle(GetTrackedMedicationsQuery(date: today))

        // Then
        XCTAssertEqual(med1.name, response.medications[0].name)
        XCTAssertTrue(response.medications[0].wasAdministered)

        XCTAssertEqual(med2.name, response.medications[1].name)
        XCTAssertFalse(response.medications[1].wasAdministered)

        XCTAssertEqual(med3.name, response.medications[2].name)
        XCTAssertTrue(response.medications[2].wasAdministered)
    }
}

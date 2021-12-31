import XCTest
@testable import MedicationApp

class TrackMedicationUseCaseTests: XCTestCase {
    var sut: TrackMedicationUseCase!
    let administrations = MockAdministrations()
    let medications = MockMedications()

    override func setUpWithError() throws {
        sut = MedicationService.factory(medications: medications, administrations: administrations)
    }

    func test_adds_new_medication_to_repository() async throws {
        // Given
        let name = "My New Med"
        let administrationTime = 10

        // When
        try await sut.handle(TrackMedicationCommand(name: name, administrationTime: administrationTime))

        // Then
        medications.verify_add_wasCalled(withName: name, andTime: administrationTime)
        medications.verify_save_wasCalled()
    }
}

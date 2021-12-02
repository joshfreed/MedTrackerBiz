import XCTest
@testable import MedicationApp

class TrackMedicationUseCaseTests: XCTestCase {
    var sut: TrackMedicationUseCase!
    let administrations = MockAdministrations()
    let medications = MockMedications()

    override func setUpWithError() throws {
        sut = MedicationService(medications: medications, administrations: administrations)
    }

    func test_adds_new_medication_to_repository() async throws {
        // Given
        let name = "My New Med"

        // When
        try await sut.handle(TrackMedicationCommand(name: name))

        // Then
        medications.verify_add_wasCalled(withName: name)
        medications.verify_save_wasCalled()
    }
}

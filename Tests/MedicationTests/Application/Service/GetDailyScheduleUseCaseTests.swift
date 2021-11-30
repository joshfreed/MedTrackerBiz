import XCTest
@testable import Medication

class GetDailyScheduleUseCaseTests: XCTestCase {
    var sut: MedicationService!
    let medications = MockMedications()

    override func setUpWithError() throws {
        continueAfterFailure = false
        sut = MedicationService(medications: medications)
    }

    func test_returns_an_empty_schedule() async throws {
        medications.medications = []

        let response = try await sut.handle(GetTrackedMedicationsQuery())

        XCTAssertEqual(0, response.medications.count)
    }

    func test_returns_tracked_medications() async throws {
        medications.medications = [
            .init(name: "Test Med 1")
        ]

        let response = try await sut.handle(GetTrackedMedicationsQuery())

        XCTAssertEqual(1, response.medications.count)
        XCTAssertEqual("Test Med 1", response.medications[0].name)
    }
}

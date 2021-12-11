import XCTest
import Combine
@testable import MedicationApp

class GetTrackMedicationsContinuousQueryTests: XCTestCase {
    var sut: MedicationService!
    let medications = MockMedications()
    let administrations = MockAdministrations()
    var cancellable: AnyCancellable?
    let today = Date()
    let med1 = Medication(name: "Testaprexin")
    let med2 = Medication(name: "Allegra")
    let med3 = Medication(name: "Beezlepill")

    override func setUpWithError() throws {
        continueAfterFailure = false
        sut = MedicationService.factory(medications: medications, administrations: administrations)
    }

    func test_first_subscriptions_fetches_current_query_state() async throws {
        // Given
        medications.configure_getAll_toReturn([med1, med2, med3])
        administrations.configure_hasAdministration_toReturn(true, on: today, for: med1.id)
        administrations.configure_hasAdministration_toReturn(false, on: today, for: med2.id)
        administrations.configure_hasAdministration_toReturn(true, on: today, for: med3.id)

        // When
        let initialValue = await subscribeToContinuousQuery()

        // Then
        XCTAssertNotNil(initialValue)
        XCTAssertEqual(3, initialValue!.medications.count)
        XCTAssertEqual(med1.name, initialValue!.medications[0].name)
        XCTAssertEqual(med2.name, initialValue!.medications[1].name)
        XCTAssertEqual(med3.name, initialValue!.medications[2].name)
        XCTAssertTrue(initialValue!.medications[0].wasAdministered)
        XCTAssertFalse(initialValue!.medications[1].wasAdministered)
        XCTAssertTrue(initialValue!.medications[2].wasAdministered)
    }

    func test_passing_a_different_date_starts_a_new_query() async throws {
        // Given
        let yesterday = Calendar.current.date(byAdding: .init(day: -1), to: today)!
        medications.configure_getAll_toReturn([med1])
        administrations.configure_hasAdministration_toReturn(true, on: yesterday, for: med1.id)
        administrations.configure_hasAdministration_toReturn(false, on: today, for: med1.id)

        let yesterdayValue = await subscribeToContinuousQuery(for: yesterday)
        let todayValue = await subscribeToContinuousQuery(for: today)

        // Then
        XCTAssertNotNil(yesterdayValue)
        XCTAssertNotNil(todayValue)
        XCTAssertNotEqual(yesterdayValue, todayValue)
        XCTAssertTrue(yesterdayValue!.medications[0].wasAdministered)
        XCTAssertFalse(todayValue!.medications[0].wasAdministered)
    }

    func test_trackMedicationUseCase_publishes_an_updated_query() async throws {
        // Given
        medications.configure_getAll_toReturn([med1])
        expectQueryToPublishNewValue()

        // When
        try await sut.handle(TrackMedicationCommand(name: "My New Med"))

        // Then
        await waitForExpectations(timeout: 5)
    }

    func test_recordAdministrationUseCase_publishes_an_updated_query() async throws {
        // Given
        medications.configure_getAll_toReturn([med1])
        medications.configure_getById_toReturn(med1, forId: med1.id)
        expectQueryToPublishNewValue()

        // When
        try await sut.handle(RecordAdministrationCommand(medicationId: String(describing: med1.id)))

        // Then
        await waitForExpectations(timeout: 5)
    }

    // MARK: - Helpers

    private func subscribeToContinuousQuery(for date: Date? = nil) async -> GetTrackedMedicationsResponse? {
        let expectation = expectation(description: "current value")

        var initialValue: GetTrackedMedicationsResponse?

        var queryDate: Date
        if let date = date {
            queryDate = date
        } else {
            queryDate = today
        }

        cancellable = sut.subscribe(.init(date: queryDate))
            .sink { completion in
                XCTFail("Should not complete")
            } receiveValue: { response in
                initialValue = response
                expectation.fulfill()
            }

        await waitForExpectations(timeout: 5)

        return initialValue
    }

    private func expectQueryToPublishNewValue() {
        let expectation = expectation(description: "Published updated query")

        cancellable = sut.subscribe(.init(date: today))
            .dropFirst() // ignores the initial fetch that happens on subscribe
            .receive(on: RunLoop.main)
            .sink { completion in
                XCTFail("Should not complete")
            } receiveValue: { response in
                expectation.fulfill()
            }
    }
}

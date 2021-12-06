import XCTest
@testable import MedicationApp

class FindMedicationByNameTests: XCTestCase {
    var sut: FindMedicationByName!
    let medications = MockMedications()

    override func setUpWithError() throws {
        sut = FindMedicationByName(medications: medications)
    }

    func test_first_() async throws {
        try await assertFindMedication(named: "Tylenol", from: ["Advil", "Tylenol"])
        try await assertFindMedication(named: "TYLENOL", from: ["Advil", "Tylenol"])
        try await assertFindMedication(named: "tylenol", from: ["Advil", "Tylenol"])
    }

    // MARK: - Helpers

    private func assertFindMedication(named name: String, from medications: [String], file: StaticString = #filePath, line: UInt = #line) async throws {
        givenMedications(medications)

        let medication = try await sut.findOne(named: name)

        XCTAssertNotNil(medication)
        XCTAssertEqual(name.lowercased(), medication?.name.lowercased())
    }

    private func givenMedications(_ medicationNames: [String]) {
        var medicationList: [Medication] = []

        for name in medicationNames {
            let medication = Medication(name: name)
            medicationList.append(medication)
        }

        medications.configure_getAll_toReturn(medicationList)
    }
}

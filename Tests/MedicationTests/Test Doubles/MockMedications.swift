import Foundation
import XCTest
@testable import MedicationApp

class MockMedications: MedicationRepository {

    // MARK: add

    var added: [Medication] = []

    func add(_ medication: Medication) async throws {
        added.append(medication)
    }

    func verify_add_wasCalled(withName name: String, file: StaticString = #filePath, line: UInt = #line) {
        guard let med = added.first(where: { $0.name == name }) else {
            XCTFail("Expected medication was not added", file: file, line: line)
            return
        }
    }

    // MARK: getAll

    var getAllResult: [Medication] = []

    func configure_getAll_toReturn(_ medications: [Medication]) {
        getAllResult = medications
    }

    func getAll() async throws -> [Medication] {
        getAllResult
    }

    // MARK: getById

    var getById_calls: [MedicationId: Medication] = [:]

    func configure_getById_toReturn(_ medication: Medication, forId medicationId: MedicationId) {
        getById_calls[medicationId] = medication
    }

    func getById(_ id: MedicationId) async throws -> Medication? {
        getById_calls[id]
    }

    // MARK: save

    var saveWasCalled = false

    func save() async throws {
        saveWasCalled = true
    }

    func verify_save_wasCalled(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(saveWasCalled, "save was not called", file: file, line: line)
    }
}

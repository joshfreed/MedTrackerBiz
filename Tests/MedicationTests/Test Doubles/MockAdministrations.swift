import Foundation
import XCTest
import MedicationApp

class MockAdministrations: AdministrationRepository {

    // MARK: add

    var added: [Administration] = []

    func add(_ administration: Administration) async throws {
        added.append(administration)
    }

    func verify_add_wasCalled(withAdministrationFor medicationId: MedicationId, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(added.contains(where: { $0.medicationId == medicationId }), file: file, line: line)
    }

    // MARK: save

    var saveWasCalled = false

    func save() async throws {
        saveWasCalled = true
    }

    func verify_save_wasCalled(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(saveWasCalled, "save was not called", file: file, line: line)
    }

    // MARK: hasAdministration

    var calls: [HasAdministrationKey: Bool] = [:]

    struct HasAdministrationKey: Hashable {
        let date: Date
        let medicationId: MedicationId
    }

    func configure_hasAdministration_toReturn(_ result: Bool, on date: Date, for medicationId: MedicationId) {
        let key = HasAdministrationKey(date: date, medicationId: medicationId)
        calls[key] = result
    }

    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        let key = HasAdministrationKey(date: date, medicationId: medicationId)
        return calls[key, default: false]
    }
}

import Foundation
import XCTest
import MedicationApp

class MockAdministrations: AdministrationRepository {

    // MARK: add

    var added: Administration?

    func add(_ administration: Administration) async throws {
        added = administration
    }

    func verify_add_wasCalled(withAdministrationFor medicationId: MedicationId, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(added?.medicationId == medicationId, file: file, line: line)
    }

    // MARK: findByMedicationIdAndDate

    var findByCalls: [MedIdDateKey: Administration] = [:]

    struct MedIdDateKey: Hashable {
        let medicationId: MedicationId
        let date: Date
    }

    func findBy(medicationId: MedicationId, and date: Date) async throws -> Administration? {
        let key = MedIdDateKey(medicationId: medicationId, date: date)
        return findByCalls[key]
    }

    func configure_findByMedicationAndDate_toReturn(_ administration: Administration, for medicationId: MedicationId, and date: Date) {
        let key = MedIdDateKey(medicationId: medicationId, date: date)
        findByCalls[key] = administration
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

    // MARK: remove

    var removedAdministration: Administration?

    func remove(_ administration: Administration) async throws {
        removedAdministration = administration
    }

    func verify_remove_wasCalled(with administration: Administration, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(removedAdministration, administration, "remove was not called w/ expected administration", file: file, line: line)
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

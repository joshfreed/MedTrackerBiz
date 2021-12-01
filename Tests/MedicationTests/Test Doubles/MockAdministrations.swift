import Foundation
import MedicationApp

class MockAdministrations: AdministrationRepository {

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

    func hasAdministration(on date: Date, for medicationId: MedicationId) -> Bool {
        let key = HasAdministrationKey(date: date, medicationId: medicationId)
        return calls[key, default: false]
    }
}

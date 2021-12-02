import XCTest
@testable import MedicationApp
@testable import JFLib_Testing

class AdministrationTests: XCTestCase {
    func test_initializes_administration_date_to_now() {
        let today = Date()
        Date.overrideCurrentDate(today)
        let medicationId = MedicationId()

        let administration = Administration(medicationId: medicationId)

        XCTAssertEqual(medicationId, administration.medicationId)
        XCTAssertEqual(today, administration.administrationDate)
    }
}

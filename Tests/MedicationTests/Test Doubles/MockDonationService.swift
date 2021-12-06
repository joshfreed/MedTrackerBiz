import Foundation
import JFLib_DomainEvents
import MedicationApp
import XCTest

class MockDonationService: ShortcutDonationService {

    // MARK: - donateInteraction

    var donateInteractionWasCalled = false
    var donatedDomainEvent: DomainEvent?

    func donateInteraction<T: DomainEvent>(domainEvent: T) {
        donateInteractionWasCalled = true
        donatedDomainEvent = domainEvent
    }

    func verify_donateInteraction_wasCalled(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(donateInteractionWasCalled, file: file, line: line)
    }
}

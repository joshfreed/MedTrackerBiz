import Foundation
import Combine

public protocol MedTrackerBackEndEvents {
    var newMedicationTracked: AnyPublisher<NewMedicationTracked, Never> { get }
    var administrationRecorded: AnyPublisher<AdministrationRecorded, Never> { get }
    var administrationRemoved: AnyPublisher<AdministrationRemoved, Never> { get }
}

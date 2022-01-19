import Foundation
import JFLib_DomainEvents

/// Represents a medication that must be administered
public struct Medication: Equatable, Codable {
    public let id: MedicationId

    /// The name of the medication
    public private(set) var name: String

    /// The hour of the day the medication should be administered
    public private(set) var administrationTime: Int

    public init(name: String, administrationTime: Int) throws {
        try self.init(id: MedicationId(), name: name, administrationTime: administrationTime)
    }

    init(id: MedicationId, name: String, administrationTime: Int) throws {
        guard administrationTime >= 0 && administrationTime < 24 else {
            throw MedicationError.invalidAdministrationTime
        }
        self.id = id
        self.name = name
        self.administrationTime = administrationTime
    }

    public static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.id == rhs.id
    }

    /// Records a new administration of this medication at the given date and time.
    ///
    /// - Parameter date: The exact date and time the medication as administered
    /// - Returns: an entity representing the new administration
    func recordAdministration(on date: Date) -> Administration {
        let administration = Administration(medicationId: id)
        DomainEvents.add(AdministrationRecorded(
            id: administration.id,
            medicationId: id,
            administrationDate: administration.administrationDate,
            medicationName: name
        ))
        return administration
    }
}

import Foundation

/// Start tracking a new medication
public struct TrackMedicationCommand {
    /// The name of the medication to track
    public let name: String

    /// The hour of the day you intend to take this medication
    public let administrationTime: Int

    /// Initializes a new `TrackMedicationCommand`
    /// - Parameters:
    ///   - name: The name of the medication to track
    ///   - administrationTime: The hour of the day you intend to take this medication
    public init(name: String, administrationTime: Int) {
        self.name = name
        self.administrationTime = administrationTime
    }
}

import Foundation

public struct TrackMedicationCommand {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

public protocol TrackMedicationUseCase {
    func handle(_ command: TrackMedicationCommand) async throws
}

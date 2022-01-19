import Foundation

public struct MedicationId: Equatable, Codable, Hashable {
    public let uuid: UUID

    public init() {
        uuid = UUID()
    }

    init?(uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else { return nil }
        self.uuid = uuid
    }
}

extension MedicationId: CustomStringConvertible {
    public var description: String { uuid.uuidString }
}

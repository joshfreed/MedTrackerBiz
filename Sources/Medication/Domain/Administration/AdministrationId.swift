import Foundation

public struct AdministrationId: Equatable, Codable {
    public let uuid: UUID

    public init() {
        uuid = UUID()
    }

    init?(uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else { return nil }
        self.uuid = uuid
    }
}

extension AdministrationId: CustomStringConvertible {
    public var description: String { uuid.uuidString }
}

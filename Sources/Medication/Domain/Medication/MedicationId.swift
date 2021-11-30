import Foundation

struct MedicationId: Equatable, Codable {
    private let uuid: UUID

    init() {
        uuid = UUID()
    }

    init?(uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else { return nil }
        self.uuid = uuid
    }
}

extension MedicationId: CustomStringConvertible {
    var description: String { uuid.uuidString }
}

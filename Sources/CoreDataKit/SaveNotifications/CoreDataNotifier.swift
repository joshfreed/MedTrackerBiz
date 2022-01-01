import Foundation
import Combine

public protocol CoreDataNotifier {
    func postCoreDataDidChange()
    func coreDataDidChange() -> AnyPublisher<Void, Never>
}

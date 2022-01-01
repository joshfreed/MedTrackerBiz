import Foundation
import Combine

extension UserDefaults {
    @objc var coreDataDidChange: Double {
        get {
            double(forKey: "coreDataDidChange")
        }

        set {
            self.set(newValue, forKey: "coreDataDidChange")
        }
    }
}

public class UserDefaultsCoreDataNotifier: CoreDataNotifier {
    public static let shared = UserDefaultsCoreDataNotifier()

    let userDefaults = UserDefaults(suiteName: "group.medtracker.core.data")!

    public func postCoreDataDidChange() {
        userDefaults.coreDataDidChange = Date().timeIntervalSince1970
    }

    public func coreDataDidChange() -> AnyPublisher<Void, Never> {
        userDefaults.publisher(for: \.coreDataDidChange)
            .print()
            .dropFirst()
            .removeDuplicates()
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

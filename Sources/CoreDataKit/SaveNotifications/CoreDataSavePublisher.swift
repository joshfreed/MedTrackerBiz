import Foundation
import CoreData
import Combine
import OSLog

class CoreDataSavePublisher {
    private var context: NSManagedObjectContext
    private var logger: Logger
    private var cancellable: AnyCancellable?

    init(context: NSManagedObjectContext, logger: Logger) {
        self.context = context
        self.logger = logger
    }

    func publishWhenCoreDataSaves() {
        cancellable = NotificationCenter.default
            .publisher(for: NSManagedObjectContext.didSaveObjectsNotification, object: context)
            .sink { [weak self] _ in
                self?.logger.debug("Received MOC didSaveObjectsNotification")
                UserDefaultsCoreDataNotifier.shared.postCoreDataDidChange()
            }
    }
}

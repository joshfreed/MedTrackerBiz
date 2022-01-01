import Foundation
import CoreData
import Combine
import OSLog

public class CoreDataSavePublisher {
    private let context: NSManagedObjectContext
    private let notifier: CoreDataNotifier
    private let logger: Logger
    private var cancellable: AnyCancellable?

    public init(
        context: NSManagedObjectContext,
        notifier: CoreDataNotifier,
        logger: Logger
    ) {
        logger.debug("CoreDataSavePublisher::init")
        self.context = context
        self.notifier = notifier
        self.logger = logger
    }

    deinit {
        logger.debug("CoreDataSavePublisher::deinit")
    }

    public func publishWhenCoreDataSaves() {
        cancellable = NotificationCenter.default
            .publisher(for: NSManagedObjectContext.didSaveObjectsNotification, object: context)
            .sink { [weak self] _ in
                self?.logger.debug("Received MOC didSaveObjectsNotification")
                self?.notifier.postCoreDataDidChange()
            }
    }

    public func stopPublishing() {
        cancellable?.cancel()
        cancellable = nil
    }
}

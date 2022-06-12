import Foundation
import Combine
import UserNotifications
import Dip
import JFLib_Services
import MTCommon
import MTBackEndCore
import MedicationContext
import OSLog

public class LocalNotificationModule: MedTrackerModule {
    private var cancellables = Set<AnyCancellable>()
    private let localNotificationHandler = LocalNotificationHandler()

    public init() {}

    public func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        switch env {
        case .live:
            container.register(.unique) { LocalNotificationService(logger: Logger.localNotifications) }.implements(NotificationService.self)
        case .test:
            container.register(.unique) { JsonNotificationStorage() }.implements(NotificationService.self)
        case .preview:
            container.register(.unique) { EmptyNotificationService() }.implements(NotificationService.self)
        }
    }

    public func bootstrap(env: XcodeEnvironment) {
        guard env == .live else { return }

        configureNotifications()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                print("user has declined notifications")
            }
        }

        localNotificationHandler.register()
    }

    private func configureNotifications() {
        let yesAction = UNNotificationAction(identifier: "YES_ACTION", title: "Yes", options: [])
        let noAction = UNNotificationAction(identifier: "NO_ACTION", title: "Not Yet", options: [])
        let medCheckInCategory = UNNotificationCategory(
            identifier: "MEDICATION_CHECK_IN",
            actions: [yesAction, noAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([medCheckInCategory])
    }
}

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let localNotifications = Logger(subsystem: subsystem, category: "localNotifications")

    func error(_ error: Error) {
        self.error("\(String(describing: error))")
    }
}

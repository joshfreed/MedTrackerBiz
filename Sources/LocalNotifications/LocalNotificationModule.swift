import Foundation
import Combine
import UserNotifications
import Dip
import JFLib_Services
import MTCommon
import MTBackEndCore
import MedicationContext

public class LocalNotificationModule: MedTrackerModule {
    private var cancellables = Set<AnyCancellable>()
    private let localNotificationHandler = LocalNotificationHandler()

    private var domainEvents: MedTrackerBackEndEvents { try! JFServices.resolve() }

    public init() {}

    public func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        switch env {
        case .live:
            container.register(.unique) { LocalNotificationService() }.implements(NotificationService.self)
        case .test:
            container.register(.unique) { EmptyNotificationService() }.implements(NotificationService.self)
        case .preview:
            container.register(.unique) { EmptyNotificationService() }.implements(NotificationService.self)
        }
    }

    public func bootstrap(env: XcodeEnvironment) {
        guard env == .live else { return }

        configureNotifications()

        localNotificationHandler.register()
    }

    private func configureNotifications() {
        let takeAction = UNNotificationAction(identifier: "TAKE_ACTION", title: "Take", options: [])
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: [])
        let medicationReminderCategory = UNNotificationCategory(
            identifier: "MEDICATION_REMINDER",
            actions: [takeAction, snoozeAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )

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
        notificationCenter.setNotificationCategories([medicationReminderCategory, medCheckInCategory])
    }
}

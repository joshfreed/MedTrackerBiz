import Foundation
import UserNotifications
import MTBackEndCore
import JFLib_Services
import OSLog

class LocalNotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    @Injected private var application: MedTrackerBackEnd
    
    func register() {
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        guard let medicationId = userInfo["medicationId"] as? String else {
            completionHandler()
            return
        }

        switch response.actionIdentifier {
        case "YES_ACTION":
            Task {
                do {
                    try await application.recordAdministration(medicationId: medicationId)
                } catch {
                    Logger.localNotifications.error(error)
                }
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        case "NO_ACTION": completionHandler()
        default: completionHandler()
        }
    }
}

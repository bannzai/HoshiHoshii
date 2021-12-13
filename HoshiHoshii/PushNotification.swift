import Foundation
import UserNotifications
import FirebaseMessaging

final class PushNotification: NSObject, ObservableObject {
    override init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }

    func retrieveAuthorizationStatus() async -> UNAuthorizationStatus {
        return await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    func requestAuthorization() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    }
}

extension PushNotification: UNUserNotificationCenterDelegate, MessagingDelegate { }

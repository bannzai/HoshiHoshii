import Foundation
import UserNotifications
import FirebaseMessaging
import UIKit

final class PushNotification: NSObject, ObservableObject {
    override init() {
        super.init()
    }

    func retrieveAuthorizationStatus() async -> UNAuthorizationStatus {
        return await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    func requestAuthorization() async {
        do {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            fatalError()
        }
    }

    func registerForRemoteNotifications() async {
        await UIApplication.shared.registerForRemoteNotifications()
    }
}

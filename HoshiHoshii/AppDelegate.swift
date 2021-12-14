import Foundation
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        Task { @MainActor in
            let authorizationStatus = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
            switch authorizationStatus {
            case .authorized, .ephemeral, .provisional:
                return
            case .denied:
                // TODO: Open Settings
                return
            case .notDetermined:
                print("[DEBUG] begin register push notification")
                do {
                    _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                } catch {
                    fatalError()
                }
                application.registerForRemoteNotifications()
                print("[DEBUG] end register push notification")
            @unknown default:
                fatalError()
            }
        }

        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken;
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("[DEBUG] Firebase token: \(String(describing: fcmToken))")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate { }

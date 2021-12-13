//
//  HoshiHoshiiApp.swift
//  HoshiHoshii
//
//  Created by 廣瀬雄大 on 2021/12/05.
//

import SwiftUI
import Firebase

@main
struct HoshiHoshiiApp: App {
    @StateObject var appViewModel = AppViewModel()
    @StateObject var pushNotification = PushNotification()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(pushNotification)
                .preferredColorScheme(.dark)
        }

    }
}

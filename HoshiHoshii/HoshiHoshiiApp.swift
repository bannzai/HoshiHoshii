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

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}

//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct UberSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var locationSearchViewModel = LocationSearchViewModel()
    @StateObject private var homeViewModel = HomeViewModel()


    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(locationSearchViewModel)
                .environmentObject(homeViewModel)
        }
    }
}

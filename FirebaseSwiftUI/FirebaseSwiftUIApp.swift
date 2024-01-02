//
//  FirebaseSwiftUIApp.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 11.11.2023.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct FirebaseSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
            RootView()
//            PerfomanceView()
//            AnalyticsView()

        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
}

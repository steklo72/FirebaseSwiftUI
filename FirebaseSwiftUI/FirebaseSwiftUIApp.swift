//
//  FirebaseSwiftUIApp.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 11.11.2023.
//

import SwiftUI
import Firebase

@main
struct FirebaseSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
            RootView()

        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

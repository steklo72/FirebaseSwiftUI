//
//  CrashManager.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 19.12.2023.
//

import Foundation
import SwiftUI
import FirebaseCrashlytics

final class CrashManager {
    static let shared = CrashManager()
    private init() {}
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    private func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    func setIsPremiumValue(isPremium: Bool) {
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    func addLogg(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
}

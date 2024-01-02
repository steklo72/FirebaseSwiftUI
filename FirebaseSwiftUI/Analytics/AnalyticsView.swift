//
//  AnalyticsView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 19.12.2023.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift

final class AnaliticsManager {
    static let shared = AnaliticsManager()
    private init() { }
    func logEvent(name: String, params: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    func setUserProperty(value: String?, property: String ) {
        Analytics.setUserProperty(value, forName: property)
    }
}

struct AnalyticsView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button {
                AnaliticsManager.shared.logEvent(name: "AnalyticsView_ButtonClick")
            } label: {
                Text("Click Me!")
            }
            Button {
                AnaliticsManager.shared.logEvent(name: "AnalyticsView_SecondaryButtonClick", params: ["ScreenTitle" : "Hello World"])
            } label: {
                Text("Click Me 2!")
            }

        }
        .analyticsScreen(name: "AnalyticsView")
        .onAppear{
            AnaliticsManager.shared.logEvent(name: "AnalyticsView_appear")
        }
        .onDisappear{
            AnaliticsManager.shared.logEvent(name: "AnalyticsView_Disappear")
            AnaliticsManager.shared.setUserId(userId: "ass")
            AnaliticsManager.shared.setUserProperty(value: true.description, property: "user_is_premium")
        }
    }
}

#Preview {
    AnalyticsView()
}

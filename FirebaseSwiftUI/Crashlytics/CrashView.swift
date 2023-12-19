//
//  CrashView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 15.12.2023.
//

import SwiftUI
import FirebaseCrashlytics



struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 40) {
                Button("Crash") {
                    CrashManager.shared.addLogg(message: "button_0_clicked")
                  fatalError("Crash was triggered")
                }
                Button("Click me 1") {
                    CrashManager.shared.addLogg(message: "button_1_clicked")
                    let myString: String? = nil
                    guard let myString else {
                        CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                        return
                    }
                    let string2 = myString
                }
                Button("Click me 2") {
                    CrashManager.shared.addLogg(message: "button_2_clicked")
                    fatalError("This was a Fatal crash")
                }
                Button("Click me 3") {
                    CrashManager.shared.addLogg(message: "button_3_clicked")
                    let array: [String] = []
                    let item = array[0]
                }
            }
        }
        .onAppear {
            CrashManager.shared.setUserId(userId: "ASS")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLogg(message: "crash_view_appeared")
            CrashManager.shared.addLogg(message: "Crash view appeared on user screen")
            
        }
    }
}

#Preview {
    CrashView()
}

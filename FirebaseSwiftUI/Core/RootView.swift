//
//  rootView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    var body: some View {
        ZStack{
            if !showSignInView {
                TabBarView(showSignInView: $showSignInView)
            }
            
        }
        .onAppear {
            let autUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = autUser == nil
            
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }

    }
}

#Preview {
    RootView()
}

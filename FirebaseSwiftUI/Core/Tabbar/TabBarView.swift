//
//  TabBarView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 10.12.2023.
//

import SwiftUI

struct TabBarView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                ProductsView()
                   
            }.tabItem {
                Image(systemName: "cart")
                Text("Товары")
            }
            NavigationStack {
                FavoriteView()
            }.tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }.tabItem {
                Image(systemName: "person")
                Text("Профиль")
            }
       
        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}

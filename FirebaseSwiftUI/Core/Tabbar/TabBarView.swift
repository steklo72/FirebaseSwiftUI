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
                CrashView()
            }.tabItem {
                Image(systemName: "house")
                Text("Главная")
            }
            NavigationStack {
                ProductsView()
                   
            }.tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("Товары")
            }
            NavigationStack {
                FavoriteView()
            }.tabItem {
                Image(systemName: "star.fill")
                Text("Избранное")
            }
            NavigationStack {
                BasketView()
            }.tabItem {
                Image(systemName: "cart")
                Text("Корзина")
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

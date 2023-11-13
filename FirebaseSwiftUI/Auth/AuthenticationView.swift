//
//  AuthenticationView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack{
            NavigationLink {
                Text("Hello")
            } label: {
                Text("Sign in with Email ")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

        }
        .padding()
            .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView()
    }
}

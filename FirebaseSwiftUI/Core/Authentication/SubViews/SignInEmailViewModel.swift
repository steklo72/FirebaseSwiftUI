//
//  SignInEmailViewModel.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 01.12.2023.
//

import Foundation

@MainActor

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp ()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Ne email or password found")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
    }
    func signIn ()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Ne email or password found")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        
    }
}

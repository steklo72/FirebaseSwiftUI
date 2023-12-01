//
//  SettingViewModel.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 01.12.2023.
//

import Foundation
@MainActor
final class SettingViewModel: ObservableObject{
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let provider =  try? AuthenticationManager.shared.getProviders() {
            authProviders = provider
        }
    }
    func loadAuthUser() {
        self.authUser =  try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        
    }
    func delete() async throws {
        try await AuthenticationManager.shared.delete()
    }
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
       try await AuthenticationManager.shared.resetPassword(email: email)
    }
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//
//
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
       try await AuthenticationManager.shared.updateEmail(email: email)
    }
    func updatePassword() async throws {
        let password = "123123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.signInGoogle(tokens: tokens)
        
    }
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.signInApple(tokens: tokens)
    }
    func linkEmailAccount() async throws {
        let email = "hello123@gmail.com"
        let password = "123123"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}

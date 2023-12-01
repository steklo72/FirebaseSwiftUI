//
//  AuthenticationViewModel.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 01.12.2023.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
//    private var currentNonce: String?
//    @Published var didSignInWithApple: Bool = false
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInGoogle(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInApple(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signInAnonymous() async throws {
        
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, email: authDataResult.email, photoUrl: authDataResult.photoUrl, dataCreated: Date())
        try await UserManager.shared.createNewUser(user: user)
//        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}

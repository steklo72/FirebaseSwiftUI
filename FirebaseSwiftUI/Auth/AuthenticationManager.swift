//
//  AuthenticationManager.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    func  getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData {
//            print(provider.providerID)
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found\(provider.providerID)")
            }
        }
        return providers
    }
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
//MARK: SIGN IN EMAIL
extension AuthenticationManager {
    @discardableResult
    func createUser (email: String, password: String) async throws -> AuthDataResultModel {
       let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
       try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: email)
    }
}

//MARK: SIGN IN SSO
extension AuthenticationManager {
    @discardableResult
    func signInGoogle(tokens: GoogleSignInResultModel) async throws ->AuthDataResultModel {
        let credentional = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
         return try await signIn(credentional: credentional)
    }
    
    @discardableResult
    func signInApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credentional = OAuthProvider.appleCredential(withIDToken: tokens.token, rawNonce: tokens.nonce, fullName: tokens.fullName)
//        let credentional = OAuthProvider.appleCredential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credentional: credentional)
           
    }
    
    func signIn(credentional: AuthCredential ) async throws ->AuthDataResultModel {
        
        let authDataResult = try await Auth.auth().signIn(with: credentional)
         return AuthDataResultModel(user: authDataResult.user)
    }
}
//MARK: SIGN IN ANONYMOUS
extension AuthenticationManager {
    @discardableResult
    func signInAnonymous() async throws ->AuthDataResultModel {
        
        let authDataResult = try await Auth.auth().signInAnonymously()
         return AuthDataResultModel(user: authDataResult.user)
    }
}

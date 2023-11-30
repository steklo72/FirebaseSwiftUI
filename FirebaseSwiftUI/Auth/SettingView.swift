//
//  SettingView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import SwiftUI
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
struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button("Logout") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
                
            }
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
            
            

        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Setting")
    }
}

#Preview {
    SettingView(showSignInView: .constant(false))
}
extension SettingView{
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset")
                    } catch {
                        print(error)
                    }
                }
                
            }
            Button("Update password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Update password")
                    } catch {
                        print(error)
                    }
                }
                
            }
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("update email")
                    } catch {
                        print(error)
                    }
                }
                
            }
        } header: {
            Text("Email functions")
        }
    }
    private var anonymousSection: some View {
        Section {
            Button("Войти Google") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("link Google")
                    } catch {
                        print(error)
                    }
                }
                
            }
            Button("Войти через Apple") {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("link Apple")
                    } catch {
                        print(error)
                    }
                }
                
            }
            Button("Войти через Email") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("link email")
                    } catch {
                        print(error)
                    }
                }
                
            }
        } header: {
            Text("Создать аккаунт")
        }
    }
}

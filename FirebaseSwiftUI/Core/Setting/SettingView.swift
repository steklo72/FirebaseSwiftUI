//
//  SettingView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import SwiftUI

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
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.delete()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Удалить учетку")
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

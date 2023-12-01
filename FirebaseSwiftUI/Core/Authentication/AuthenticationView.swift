//
//  AuthenticationView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}


struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInAnonymous()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Text("Войти как Гость")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            })
            
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Вход/регистрация по эл. почте")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            HStack {
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                })
            }
//            Button(action: {
//                Task {
//                    do {
//                        try await viewModel.signInApple()
//                        showSignInView = false
//                    } catch {
//                        print(error)
//                    }
//                }
//            }, label: {
//                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
//                    .allowsHitTesting(false)
//            })
            
                .frame(height: 55)
            Spacer()
//                .onChange(of: viewModel.didSignInWithApple) { newValue in
//                    if newValue == true {
//                        showSignInView = false
//                    }
//                }
        }
        .padding()
            .navigationTitle("Регистрация")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}

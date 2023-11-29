//
//  SignInEmailView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 13.11.2023.
//

import SwiftUI
@MainActor


final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp ()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Ne email or password found")
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        
    }
    func signIn ()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Ne email or password found")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        
    }
}

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack {
            TextField("Введите эл. почту", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Введите пароль", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            Button {
                Task {
                    do {
                        try await  viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    do {
                        try await  viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Регистрация")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
Spacer()
        }
        .padding()
        .navigationTitle("Регистрация")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}

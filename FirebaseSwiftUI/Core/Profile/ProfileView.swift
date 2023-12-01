//
//  ProfileView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 01.12.2023.
//

import SwiftUI
@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
    }
    
}
struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous \(isAnonymous.description.capitalized)")
                }
            }
            
        }
        .task {
            try? await viewModel.loadCurrentUser()

        }
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                
                NavigationLink {
                    SettingView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }

            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
    
}
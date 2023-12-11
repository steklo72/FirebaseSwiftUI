//
//  FavoriteView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 10.12.2023.
//

import SwiftUI
@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func addListenerForFavotites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            return
        }
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
            self?.userFavoriteProducts = products
        }
    }
    
//    func getFavorites() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//            
//        }
//    }
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
//            getFavorites()
        }
    }
}

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var didAppear: Bool = false
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu{
                        Button("Удалить из избранного") {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                        
                    }
                
                
            }
        }
        .navigationTitle("Избранное")
        .onAppear {
//            viewModel.getFavorites()
            if !didAppear {
                viewModel.addListenerForFavotites()
                didAppear = true
            }
            
        }
    }
}

#Preview {
    NavigationStack{
        FavoriteView()
    }
    
}

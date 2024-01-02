//
//  BasketViewModel.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 02.01.2024.
//

import SwiftUI
import Combine
@MainActor

final class BasketViewModel: ObservableObject {
    @Published private(set) var userBasketProducts: [UserBasketProduct] = []
    
    private var cancellables = Set<AnyCancellable> ()
    
    func addListenerForBasket() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            return
        }
//        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
//            self?.userFavoriteProducts = products
//        }
        UserManager.shared.addListenerForAllUserBasketProducts(userId: authDataResult.uid)
            .sink { compition in
                
            } receiveValue: { [weak self] products in
                self?.userBasketProducts = products
            }
            .store(in: &cancellables)

    }
    func removeFromBasket(basketProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserBasketProduct(userId: authDataResult.uid, basketProductId: basketProductId)
            //            getFavorites()
        }
    }
}

//
//  FavoriteView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 10.12.2023.
//

import SwiftUI
import Combine
@MainActor


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
        
//        .onAppear {
////            viewModel.getFavorites()
//            viewModel.addListenerForFavotites()
//            didAppear = true
//            
//        }
        .onFirstAppear {
            viewModel.addListenerForFavotites()
        }
    }
}

#Preview {
    NavigationStack{
        FavoriteView()
    }
    
}


//
//  BasketView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 02.01.2024.
//

import SwiftUI

struct BasketView: View {
    @StateObject private var viewModel = BasketViewModel()
    @State private var didAppear: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.userBasketProducts, id: \.id.self) { item in
                    ProductCellViewBuilder(productId: String(item.productId))
                        .contextMenu{
                            Button("Удалить из корзины") {
                                viewModel.removeFromBasket(basketProductId: item.id)
                            }
                            
                        }
                    
                    
                }
            }
        }
        .onFirstAppear {
            viewModel.addListenerForBasket()
        }
                    .navigationTitle("Корзина")
    }
}

#Preview {
    BasketView()
}

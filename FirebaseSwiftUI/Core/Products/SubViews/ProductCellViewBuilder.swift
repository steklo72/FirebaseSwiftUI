//
//  ProductCellViewBuilder.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 10.12.2023.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    let productId: String
    @State private var product: Product? = nil
    var body: some View {
        ZStack{
            if let product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "1")
}

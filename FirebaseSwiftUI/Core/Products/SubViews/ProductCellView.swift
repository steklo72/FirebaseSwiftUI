//
//  ProductCellView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 05.12.2023.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                Text("Цена " + String(product.price ?? 0) + " $")
                Text(String(product.rating ?? 0) + " Рейтинг")
                Text("Категория " + (product.category ?? "n/a"))
                Text("Бренд " + (product.brand ?? "n/a"))
                
            }
            .font(.callout)
            .foregroundStyle(Color.secondary)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test1", description: "test", price: 33, discountPercentage: 1.3, rating: 3.4, stock: 44, brand: "Test", category: "Test", thumbnail: "", images: nil))
}

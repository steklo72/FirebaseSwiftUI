//
//  ProductsView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 04.12.2023.
//

import SwiftUI
import FirebaseFirestore
@MainActor


struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
//        Button("Fetch more object") {
//            viewModel.getProductsByRating()
//        }
        List {
            ForEach(viewModel.products) { product in
               ProductCellView(product: product)
                    .contextMenu(menuItems: {
                        Button("Добавить в избранное") {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                        Button("Добавить в корзину") {
                            viewModel.addUserBasketProduct(productId: product.id)
                        }
                        
                    })
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear{
                           
                            viewModel.getProducts()
                        }
                }
                
            }
        }
        .navigationTitle("Товары")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Фильтр: \(viewModel.selectedFilter?.rawValue ?? "без фильтра")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(filterOption.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }

                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Категория: \(viewModel.selectedCategory?.rawValue ?? "Без Категории")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { categoryOption in
                        Button(categoryOption.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: categoryOption)
                            }
                        }

                    }
                }
            }
        })
        .onAppear {
            viewModel.getProducts()
//            viewModel.getProductsCount()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}

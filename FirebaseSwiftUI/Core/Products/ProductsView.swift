//
//  ProductsView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 04.12.2023.
//

import SwiftUI
import FirebaseFirestore
@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts()
//        
//        
//    }
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self  {
            case .noFilter : return nil
            case .priceHigh : return true
            case .priceLow : return false
            }
        }
        
    }
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
//        switch option {
//        case .noFilter :
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .priceHigh :
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(decending: true)
//          
//        case .priceLow :
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(decending: false)
//        }
       
    }
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
        
    }
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
//        switch option {
//        case .noCategory:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .smartphones :
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//        case .laptops :
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//          
//        case .fragrances :
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//        }
      
        
    }
    func getProducts() {
        print("Last DOC")
        print(lastDocument)
        Task {
           let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
                    self.products.append(contentsOf: newProducts)
                    self.lastDocument = lastDocument
        }
        
    }
    //MARK: Дополнительная загрузок по последнему элементу
    
//    func getProductsByRating() {
//        Task {
////            let newProduct = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating)
//            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 5, lastDocument: lastDocument)
//            self.products.append(contentsOf: newProducts)
//            self.lastDocument = lastDocument
//        }
//    }

}


struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
//        Button("Fetch more object") {
//            viewModel.getProductsByRating()
//        }
        List {
            ForEach(viewModel.products) { product in
               ProductCellView(product: product)
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear{
                            print("refething")
                            viewModel.getProducts()
                        }
                }
                
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "None")") {
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
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "None")") {
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
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}

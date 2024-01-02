//
//  ProductsViewModel.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 11.12.2023.
//
import Foundation
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
        case noFilter = "Без "
        case priceHigh = "От высокой цены"
        case priceLow = "От низкой цены"
        
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
        case noCategory = "-"
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
        
        Task {
           let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
                    self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
           
        }
        
    }
    
    func getProductsCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductCount()
            print("GETTED PRODUCT CAOUNT: \(count)")
        }
    }
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
        
        
    }
    func addUserBasketProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserBasketProduct(userId: authDataResult.uid, productId: productId)
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

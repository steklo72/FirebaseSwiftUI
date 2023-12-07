//
//  ProductsDatabase.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 04.12.2023.
//

import Foundation
struct ProductArray: Codable {
    let products: [Product]
    let total, skip, limit: Int
}
struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let description: String?
    let price: Int?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Double?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case category
        case thumbnail
        case images
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    
}



//import SwiftUI
//@MainActor
//final class ProductsViewModel: ObservableObject {
//    
//    
//    
////    func downloadProductsAndUploadToFirebase() {
////        // https://dummyjson.com/products
////        guard let url = URL(string: "https://dummyjson.com/products") else { return }
////        Task {
////            do {
////                let (data, _) = try await URLSession.shared.data(from: url)
////                let products = try JSONDecoder().decode(ProductArray.self, from: data)
////                let productArray = products.products
////
////                for product in productArray {
////                    try? await ProductsManager.shared.uploadProduct(product: product)
////                }
////
////                print("Success")
////                print(products.products.count)
////            } catch {
////                print(error)
////            }
////        }
////    }
//}
//
//
//struct ProductsView: View {
//    @StateObject private var viewModel = ProductsViewModel()
//    var body: some View {
//        ZStack {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                .navigationTitle("Products")
////                .onAppear {
//////                    viewModel.downloadProductsAndUploadToFirebase()
////            }
//               
//        }
//    }
//}

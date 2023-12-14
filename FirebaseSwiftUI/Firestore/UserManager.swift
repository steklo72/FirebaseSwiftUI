//
//  UserManager.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 01.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct Movie: Codable {
    let id: String
    let title: String
    let popular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dataCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    
    
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dataCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }
    
    init(userId: String,
    isAnonymous: Bool? = nil,
    email: String? = nil,
    photoUrl: String? = nil,
    dataCreated: Date? = nil,
    isPremium: Bool? = nil,
    preferences: [String]? = nil,
    favoriteMovie: Movie? = nil,
    profileImagePath: String? = nil,
    profileImagePathUrl: String? = nil
           ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dataCreated = dataCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
//    func tooglePremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dataCreated: dataCreated, isPremium: !currentValue)
//    }
    
//    mutating func tooglePremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dataCreated = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dataCreated = try container.decodeIfPresent(Date.self, forKey: .dataCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dataCreated, forKey: .dataCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
    }
    
    
    
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    private let UserCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        UserCollection.document(userId)
    }
    
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    
    //MARK: ВТОРОЙ ВАРИАНТ ИСПОЛЬЗОВАНИЯ
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private var userFavoriteProductsListener: ListenerRegistration? = nil
//    func createNewUser(user: DBUser) async throws {
//    try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
//}
//    func getUser(userId: String) async throws -> DBUser {
//         try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
//        
//    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String: Any] = [
//            "user_id" : auth.uid,
//            "is_anonymous" : auth.isAnonymous,
//            "data_created" : Timestamp(),
//            
//        ]
//        if let email = auth.email {
//            userData["email"] = email
//        }
//        if let photoUrl = auth.photoUrl {
//            userData["photo_url"] = photoUrl
//        }
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
////        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
//    }
    func getUser(userId: String) async throws -> DBUser {
         try await userDocument(userId: userId).getDocument(as: DBUser.self)
        
    }
    
//    func getUser(userId: String) async throws -> DBUser {
//        
//        
//        let snapshot = try await userDocument(userId: userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let dataCreated = data["data_created"] as? Date
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dataCreated: dataCreated)
//    }
//    func updateUserPremiumStatus(user: DBUser) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
//            "custom_key" : "123"
            ]
        try await userDocument(userId: userId).updateData(data)
    }
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url
//            "custom_key" : "123"
            ]
        try await userDocument(userId: userId).updateData(data)
    }
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
            ]
        try await userDocument(userId: userId).updateData(data)
    }
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
            ]
        try await userDocument(userId: userId).updateData(data)
    }
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else {
            throw URLError(.badURL)
        }
        let dict: [String: Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : data
            ]
        try await userDocument(userId: userId).updateData(dict)
    }
    func removeFavoriteMovie(userId: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : nil
            ]
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        let document = userFavoriteProductCollection(userId: userId).document()
//        let document = userDocument(userId: userId).collection("favorite_products").document()
        let documentId  = document.documentID
        let data: [String:Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue : documentId,
            UserFavoriteProduct.CodingKeys.productId.rawValue : productId,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue : Timestamp()
            
        
        ]
        
        try await document.setData(data, merge: false)
    }
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
//        try await userDocument(userId: userId).collection("favorite_products").document(favoriteProductId).delete()
    
    }
    func getAllUserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No document")
                return
            }
            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                  print("New products: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                  print("Modified products: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                  print("Removed products: \(diff.document.data())")
                }
              }
        }
    }
//    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
//        let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
//        
//        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("No document")
//                return
//            }
//            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
//            publisher.send(products)
//            
//            
//        }
//        return publisher.eraseToAnyPublisher()
//    }
    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId)
            .addSnapshotListener(as: UserFavoriteProduct.self)
        self.userFavoriteProductsListener = listener
        return publisher
    }
}

struct UserFavoriteProduct: Codable {
    let id: String
    let productId: Int
    let dateCreated: Date
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
   
    
    
}

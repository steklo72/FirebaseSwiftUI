//
//  UserManager.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 01.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dataCreated: Date?
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    private let UserCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        UserCollection.document(userId)
    }
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
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
}

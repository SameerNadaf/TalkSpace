//
//  UserManager.swift
//  TalkSpace
//
//  Created by Sameer  on 12/09/25.
//

import Foundation
import FirebaseFirestore

final class UserManager {
    
    static let shared = UserManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveUserProfile(userId: String, email: String, profileImageURL: URL?) async throws {
        let userRef = db.collection("users").document(userId)
        let userName = email.split(separator: "@").first ?? ""
        var data: [String: Any] = [
            "userName": userName,
            "email": email,
            "userId": userId
        ]
        if let url = profileImageURL {
            data["profileImageURL"] = url.absoluteString
        }
        try await userRef.setData(data, merge: true)
    }
    
    func fetchUserProfile(userId: String) async throws -> (userName: String, email: String, profileImageURL: URL?) {
        let userRef = db.collection("users").document(userId)
        let document = try await userRef.getDocument()
        
        guard let data = document.data() else {
            throw NSError(domain: "UserManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        let userName = data["userName"] as? String ?? "Unknown"
        let email = data["email"] as? String ?? "unknown@example.com"
        let profileImageURL = (data["profileImageURL"] as? String).flatMap { URL(string: $0) }
        
        return (userName, email, profileImageURL)
    }
    
    func updateUserName(userId: String, userName: String) async throws {
        let userRef = db.collection("users").document(userId)
        try await userRef.setData(["userName": userName], merge: true)
    }
    
    func getAllUsers() async throws -> [QueryDocumentSnapshot] {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: snapshot?.documents ?? [])
                }
            }
        }
    }
}

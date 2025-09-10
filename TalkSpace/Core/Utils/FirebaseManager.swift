//
//  FirebaseManager.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class FirebaseManager: FirebaseManagable {
    
    static let shared = FirebaseManager()
    
    let auth: Auth
    private let storage: Storage
    private let db: Firestore
    
    private init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.db = Firestore.firestore()
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResult {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func createUserWithEmail(email: String, password: String) async throws -> AuthDataResult {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func currentUser() -> User? {
        return auth.currentUser
    }
    
    func uploadProfileImage(userId: String, imageData: Data) async throws -> URL {
        let reference = storage.reference().child("profileImages/\(userId).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = try await reference.putDataAsync(imageData, metadata: metadata)
        let url = try await reference.downloadURL()
        return url
    }
    
    func saveUserProfile(userId: String, email: String, profileImageURL: URL?) async throws {
        let userRef = db.collection("users").document(userId)
        
        var data: [String: Any] = [
            "email": email,
            "userId": userId
        ]
        
        if let url = profileImageURL {
            data["profileImageURL"] = url.absoluteString
        }
        
        try await userRef.setData(data, merge: true)
    }

    
}

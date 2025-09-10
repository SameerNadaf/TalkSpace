//
//  AuthService.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth

final class AuthService: AuthServicable {
    
    private let firebaseManager: FirebaseManagable
    
    init(firebaseManager: FirebaseManagable = FirebaseManager.shared) {
        self.firebaseManager = firebaseManager
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await firebaseManager.signInWithEmail(email: email, password: password)
    }
    
    func register(email: String, password: String, imageData: Data?) async throws -> AuthDataResult {
        let result = try await firebaseManager.createUserWithEmail(email: email, password: password)
        let userId = result.user.uid
        
        if let data = imageData {
            let url = try await firebaseManager.uploadProfileImage(userId: userId, imageData: data)
            try await firebaseManager.saveUserProfile(userId: userId, email: email, profileImageURL: url)
        }
        
        return result
    }
    
    func signOut() throws {
        try firebaseManager.signOut()
    }
    
    func currentUser() -> User? {
        firebaseManager.currentUser()
    }
}

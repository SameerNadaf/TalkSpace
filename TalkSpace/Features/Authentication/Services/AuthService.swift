//
//  AuthService.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth

final class AuthService: AuthServicable {
    
    private let authManager = AuthManager.shared
    private let storageManager = StorageManager.shared
    private let userManager = UserManager.shared
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await authManager.signIn(email: email, password: password)
    }
    
    func register(email: String, password: String, imageData: Data?) async throws -> AuthDataResult {
        let result = try await authManager.createUser(email: email, password: password)
        let userId = result.user.uid
        
        if let data = imageData {
            let url = try await storageManager.uploadProfileImage(userId: userId, imageData: data)
            try await userManager.saveUserProfile(userId: userId, email: email, profileImageURL: url)
        } else {
            try await userManager.saveUserProfile(userId: userId, email: email, profileImageURL: nil)
        }
        
        return result
    }
}


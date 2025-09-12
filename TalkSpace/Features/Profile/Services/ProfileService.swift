//
//  ProfileService.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import Foundation

protocol ProfileServicable {
    func fetchUserProfile(userId: String) async throws -> UserProfile
    func updateProfileImage(userId: String, imageData: Data) async throws -> URL
    func saveUserProfile(userId: String, email: String, profileImageURL: URL) async throws
    func updateUserName(userId: String, userName: String) async throws
}

final class ProfileService: ProfileServicable {
    
    private let userManager = UserManager.shared
    private let storageManager = StorageManager.shared
    
    func fetchUserProfile(userId: String) async throws -> UserProfile {
        let result = try await userManager.fetchUserProfile(userId: userId)
        return UserProfile(userName: result.userName, email: result.email, profileImageURL: result.profileImageURL)
    }
    
    func updateProfileImage(userId: String, imageData: Data) async throws -> URL {
        try await storageManager.uploadProfileImage(userId: userId, imageData: imageData)
    }
    
    func saveUserProfile(userId: String, email: String, profileImageURL: URL) async throws {
        try await userManager.saveUserProfile(userId: userId, email: email, profileImageURL: profileImageURL)
    }
    
    func updateUserName(userId: String, userName: String) async throws {
        try await userManager.updateUserName(userId: userId, userName: userName)
    }
    
}

//
//  FirebaseManagable.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth

protocol FirebaseManagable {
    var auth: Auth { get }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResult
    func createUserWithEmail(email: String, password: String) async throws -> AuthDataResult
    func signOut() throws
    func currentUser() -> User?
    
    func uploadProfileImage(userId: String, imageData: Data) async throws -> URL
    func saveUserProfile(userId: String, email: String, profileImageURL: URL?) async throws
}

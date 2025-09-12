//
//  AuthManager.swift
//  TalkSpace
//
//  Created by Sameer  on 12/09/25.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    private let auth = Auth.auth()
    
    private init() {}
    
    var currentUser: User? {
        auth.currentUser
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}

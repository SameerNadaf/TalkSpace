//
//  FirebaseManager.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth

final class FirebaseManager: FirebaseManaging {
    
    static let shared = FirebaseManager()
    
    let auth: Auth
    
    private init() {
        self.auth = Auth.auth()
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
}

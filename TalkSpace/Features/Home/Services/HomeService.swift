//
//  HomeService.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import Firebase
import FirebaseAuth

protocol HomeServicable {
    func signOut() throws
    func currentUser() -> User?
    func listenForRecentMessages(completion: @escaping ([RecentMessage]) -> Void) -> ListenerRegistration?
    func deleteRecentChat(message: RecentMessage) async throws
}

final class HomeService: HomeServicable {
    
    private let authManager = AuthManager.shared
    private let chatManager = ChatManager.shared
    
    func signOut() throws {
        try authManager.signOut()
    }
    
    func currentUser() -> User? {
        authManager.currentUser
    }
    
    func listenForRecentMessages(completion: @escaping ([RecentMessage]) -> Void) -> ListenerRegistration? {
        guard let userId = authManager.currentUser?.uid else {
            return nil
        }
        return chatManager.listenForRecentMessages(userId: userId, completion: completion)
    }
    
    func deleteRecentChat(message: RecentMessage) async throws {
        guard let currentUserId = authManager.currentUser?.uid else {
            throw NSError(domain: "HomeService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        try await chatManager.deleteRecentChat(userId: currentUserId, messageId: message.id)
    }
}


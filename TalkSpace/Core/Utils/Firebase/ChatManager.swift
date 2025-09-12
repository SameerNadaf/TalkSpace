//
//  ChatManager.swift
//  TalkSpace
//
//  Created by Sameer  on 12/09/25.
//

import Foundation
import FirebaseFirestore

final class ChatManager {
    
    static let shared = ChatManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func sendMessage(fromId: String, toId: String, messageData: [String: Any]) async throws {
        let docId = UUID().uuidString
        
        let senderMessageRef = db.collection("messages")
            .document(fromId)
            .collection(toId)
            .document(docId)
        try await senderMessageRef.setData(messageData)
        
        let receiverMessageRef = db.collection("messages")
            .document(toId)
            .collection(fromId)
            .document(docId)
        try await receiverMessageRef.setData(messageData)
    }
    
    func listenForMessages(fromId: String, toId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) -> ListenerRegistration {
        let messagesRef = db.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp", descending: false)
        
        return messagesRef.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let messages = snapshot?.documents.map { $0.data() } ?? []
            completion(.success(messages))
        }
    }
    
    func persistRecentMessages(fromId: String, toId: String, fromData: [String: Any], toData: [String: Any]) async throws {
        let fromDoc = db.collection("recent_messages")
            .document(fromId)
            .collection("messages")
            .document(toId)
        
        let toDoc = db.collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(fromId)
        
        try await fromDoc.setData(fromData)
        try await toDoc.setData(toData)
    }
    
    func listenForRecentMessages(userId: String, completion: @escaping ([RecentMessage]) -> Void) -> ListenerRegistration {
        let ref = db.collection("recent_messages")
            .document(userId)
            .collection("messages")
            .order(by: "timestamp", descending: true)
        
        return ref.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            let messages = documents.map { RecentMessage(id: $0.documentID, data: $0.data()) }
            completion(messages)
        }
    }
    
    func deleteRecentChat(userId: String, messageId: String) async throws {
        let ref = db.collection("recent_messages")
            .document(userId)
            .collection("messages")
            .document(messageId)
        try await ref.delete()
    }
}

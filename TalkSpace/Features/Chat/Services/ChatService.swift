//
//  ChatService.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import Foundation
import Firebase

protocol ChatServicable {
    func fetchAllUsers(excluding userId: String) async -> [ChatUser]
    func sendMessage(fromId: String, toId: String, text: String) async throws
    func listenForMessages(fromId: String, toId: String, completion: @escaping (Result<[Message], Error>) -> Void) -> ListenerRegistration
    func persistRecentMessage(fromId: String, toId: String, text: String, profileImageUrl: String, userName: String, currentUserName: String, currentUserProfileImageURL: String) async throws

}

final class ChatService: ChatServicable {
    
    private let userManager = UserManager.shared
    private let chatManager = ChatManager.shared
    
    func fetchAllUsers(excluding userId: String) async -> [ChatUser] {
        do {
            let documents = try await userManager.getAllUsers()
            let users = documents.compactMap { doc -> ChatUser? in
                if doc.documentID == userId { return nil }
                let data = doc.data()
                guard let userName = data["userName"] as? String,
                      let email = data["email"] as? String else { return nil }
                let profileImageURL = data["profileImageURL"] as? String
                return ChatUser(id: doc.documentID, userName: userName, email: email, profileImageURL: profileImageURL)
            }
            print("Fetched Users: \(users)")
            return users
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    
    func sendMessage(fromId: String, toId: String, text: String) async throws {
        let messageData: [String: Any] = [
            "text": text,
            "fromId": fromId,
            "toId": toId,
            "timestamp": Timestamp()
        ]
        try await chatManager.sendMessage(fromId: fromId, toId: toId, messageData: messageData)
    }
    
    func persistRecentMessage(fromId: String, toId: String, text: String, profileImageUrl: String, userName: String, currentUserName: String, currentUserProfileImageURL: String) async throws {
        let timestamp = Timestamp()
        
        let fromData: [String: Any] = [
            "text": text,
            "fromId": fromId,
            "toId": toId,
            "profileImageURL": profileImageUrl,
            "userName": userName,
            "timestamp": timestamp
        ]
        
        let toData: [String: Any] = [
            "text": text,
            "fromId": fromId,
            "toId": toId,
            "profileImageURL": currentUserProfileImageURL,
            "userName": currentUserName,
            "timestamp": timestamp
        ]
        
        try await chatManager.persistRecentMessages(fromId: fromId, toId: toId, fromData: fromData, toData: toData)
    }
    
    func listenForMessages(fromId: String, toId: String, completion: @escaping (Result<[Message], Error>) -> Void) -> ListenerRegistration {
        return chatManager.listenForMessages(fromId: fromId, toId: toId) { result in
            switch result {
            case .success(let rawData):
                let messages = rawData.compactMap { data -> Message? in
                    guard let text = data["text"] as? String,
                          let fromId = data["fromId"] as? String,
                          let toId = data["toId"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    return Message(
                        id: UUID().uuidString,
                        text: text,
                        fromId: fromId,
                        toId: toId,
                        timestamp: timestamp.dateValue()
                    )
                }
                completion(.success(messages))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

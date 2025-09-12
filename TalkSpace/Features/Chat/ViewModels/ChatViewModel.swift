//
//  ChatViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import Foundation
import Firebase
import SwiftUI

final class ChatViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var textHeight: CGFloat = 40
    @Published var messages: [Message] = []
    
    let chatUser: ChatUser?
    
    private let chatService: ChatServicable
    private let authManager = AuthManager.shared
    private let userManager = UserManager.shared
    private var listener: ListenerRegistration?
    
    init(chatUser: ChatUser?,
         chatService: ChatServicable = ChatService()) {
        self.chatUser = chatUser
        self.chatService = chatService
    }
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    func sendMessage() async {
        guard let fromId = authManager.currentUser?.uid,
              let toId = chatUser?.id else { return }
        
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        do {
            try await chatService.sendMessage(fromId: fromId, toId: toId, text: trimmedText)
            await persistRecentMessage(trimmedText: trimmedText)
            await MainActor.run {
                withAnimation(.easeOut) {
                    messageText = ""
                }
            }
            print("Message sent successfully!")
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }

    func persistRecentMessage(trimmedText: String) async {
        guard let fromId = authManager.currentUser?.uid,
              let toId = chatUser?.id,
              let profileImageURL = chatUser?.profileImageURL,
              let userName = chatUser?.userName else { return }
        
        do {
            let currentUser = try await userManager.fetchUserProfile(userId: fromId)
            
            try await chatService.persistRecentMessage(
                fromId: fromId,
                toId: toId,
                text: trimmedText,
                profileImageUrl: profileImageURL,
                userName: userName,
                currentUserName: currentUser.userName,
                currentUserProfileImageURL: currentUser.profileImageURL?.absoluteString ?? ""
            )
            print("Recent message persisted successfully!")
        } catch {
            print("Error persisting recent message: \(error.localizedDescription)")
        }
    }

    
    func startListening() {
        guard let fromId = authManager.currentUser?.uid,
              let toId = chatUser?.id else { return }
        
        listener = chatService.listenForMessages(fromId: fromId, toId: toId) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messages = messages
            case .failure(let error):
                print("Error listening for messages: \(error.localizedDescription)")
            }
        }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func calculateTextHeight() {
        let font = UIFont.systemFont(ofSize: 17)
        let width = UIScreen.main.bounds.width - 24 - 48 - 40 // Adjusted width considering padding and buttons
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let text = messageText as NSString
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        textHeight = rect.height + 20 // Adding padding
    }
}


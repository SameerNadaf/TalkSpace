//
//  ChatViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import Foundation
import Firebase
import SwiftUI
import PhotosUI
import Combine

final class ChatViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var textHeight: CGFloat = 40
    @Published var isUploadingImage: Bool = false
    @Published var messages: [Message] = []
    
    @Published var photoPickerItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    private var cancellables = Set<AnyCancellable>()
    
    let chatUser: ChatUser?
    
    private let chatService: ChatServicable
    private let authManager = AuthManager.shared
    private let userManager = UserManager.shared
    
    private var listener: ListenerRegistration?
    
    init(chatUser: ChatUser?, chatService: ChatServicable = ChatService()) {
        self.chatUser = chatUser
        self.chatService = chatService
        
        photoSubscriber()
    }
    
    func photoSubscriber() {
        $photoPickerItem
            .compactMap { $0 }
            .sink { [weak self] item in
                guard let self else { return }
                Task { @MainActor in
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        self.selectedImage = image
                    }
                }
            }
            .store(in: &cancellables)
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
        guard !trimmedText.isEmpty || selectedImage != nil else { return }
        
        await MainActor.run { isUploadingImage = true }
        
        do {
            var imageURLString: String? = nil
            
            if let image = selectedImage {
                let uploadedURL = try await chatService.uploadChatImage(fromId: fromId, toId: toId, image: image)
                imageURLString = uploadedURL.absoluteString
                await MainActor.run {
                    isUploadingImage = false
                }
            }
            
            let messageToSend = trimmedText.isEmpty ? "[Image]" : trimmedText
            try await chatService.sendMessage(fromId: fromId, toId: toId, text: messageToSend, imageURL: imageURLString)
            
            await persistRecentMessage(trimmedText: messageToSend)
        
            await MainActor.run {
                withAnimation {
                    selectedImage = nil
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


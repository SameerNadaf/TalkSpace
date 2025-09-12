//
//  ChatView.swift
//  TalkSpace
//
//  Created by Sameer on 11/09/25.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    
    let chatUser: ChatUser
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isTextEditorFocused: Bool
    
    init(chatUser: ChatUser) {
        self.chatUser = chatUser
        self._viewModel = StateObject(wrappedValue: ChatViewModel(chatUser: chatUser))
    }
    
    var body: some View {

        VStack {
            // Chat messages area
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageRow(
                                isCurrentUser: message.fromId == AuthManager.shared.currentUser?.uid,
                                message: message.text,
                                time: viewModel.format(date: message.timestamp)
                            )
                            .id(message.id) // For scroll-to-bottom
                        }
                    }
                    .padding()
                    
                }
                .onTapGesture {
                    isTextEditorFocused = false
                }
                .onChange(of: viewModel.messages.count) {
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
                
            }
            
            // Message input area
            messageInputView
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.secondarySystemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 10) {
                    if let urlString = chatUser.profileImageURL {
                        RemoteImageView(urlString: urlString, size: 32)
                    }
                    Text(chatUser.userName)
                        .font(.headline)
                }
            }
        }
        .task {
            viewModel.startListening()
        }
        .onDisappear {
            viewModel.stopListening()
        }
        
    }
}

extension ChatView {
    private var messageInputView: some View {
        HStack {
            TextEditor(text: $viewModel.messageText)
                .frame(height: min(max(viewModel.textHeight, 40), 80))
                .padding(8)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .animation(.easeInOut(duration: 0.2), value: viewModel.textHeight)
                .onChange(of: viewModel.messageText) {
                    viewModel.calculateTextHeight()
                }
                .focused($isTextEditorFocused)
            
            if !viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Button {
                    Task {
                        await viewModel.sendMessage()
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        
                }
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut(duration: 0.2), value: viewModel.messageText)
            }
            
            Button {
                print("Upload image tapped")
            } label: {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.leading, 8)
                    
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.messageText)
    }
}

#Preview {
    let user = ChatUser(
        id: "123",
        userName: "User Name",
        email: "user@example.com",
        profileImageURL: "https://picsum.photos/200"
    )
    NavigationStack {
        ChatView(chatUser: user)
    }
}


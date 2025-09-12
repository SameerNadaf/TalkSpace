//
//  NewChatViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI

@MainActor
final class NewChatViewModel: ObservableObject {
    @Published var users: [ChatUser] = []
    @Published var searchText: String = ""
    
    private var allUsers: [ChatUser] = []
    private let chatService: ChatServicable
    
    init(chatService: ChatServicable = ChatService()) {
        self.chatService = chatService
    }
    
    func fetchUsers() async {
        guard let currentUser = AuthManager.shared.currentUser else { return }
        let fetchedUsers = await chatService.fetchAllUsers(excluding: currentUser.uid)
        self.allUsers = fetchedUsers
        self.applySearch()
    }
    
    func applySearch() {
        if searchText.isEmpty {
            users = allUsers
        } else {
            let lowercasedQuery = searchText.lowercased()
            users = allUsers.filter { user in
                user.userName.lowercased().contains(lowercasedQuery) ||
                user.email.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    func resetSearch() {
        searchText = ""
        KeyboardUtils.hideKeyboard()
        applySearch()
    }
}


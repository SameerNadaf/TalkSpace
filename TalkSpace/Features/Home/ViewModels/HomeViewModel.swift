//
//  HomeViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI
import Firebase

final class HomeViewModel: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var searchText: String = ""
    
    @Published var showActionSheet: Bool = false
    @Published var isLogOutTapped: Bool = false
    @Published var openProfile: Bool = false
    @Published var openNewChat: Bool = false
    
    @Published private(set) var recentMessages: [RecentMessage] = []
    private var allMessages: [RecentMessage] = []
    
    @Published var showDeleteAlert = false
    @Published var selectedMessage: RecentMessage? = nil
    
    private var listener: ListenerRegistration?
    private let homeService: HomeServicable
    
    init(homeService: HomeServicable = HomeService()) {
        self.homeService = homeService
        startListening()
    }
    
    func logOut() {
        try? homeService.signOut()
    }
    
    func startListening() {
        stopListening()
        self.allMessages.removeAll()
        self.recentMessages.removeAll()
        
        listener = homeService.listenForRecentMessages { [weak self] messages in
            guard let self = self else { return }
            self.allMessages = messages
            self.applySearch()
        }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    @MainActor
    func deleteRecentChat(_ message: RecentMessage) async {
        do {
            try await homeService.deleteRecentChat(message: message)
            self.allMessages.removeAll { $0.id == message.id }
            self.applySearch()
        } catch {
            print("Failed to delete recent chat:", error.localizedDescription)
        }
    }
    
    func applySearch() {
        if searchText.isEmpty {
            self.recentMessages = allMessages
        } else {
            let lowercasedQuery = searchText.lowercased()
            self.recentMessages = allMessages.filter {
                $0.userName.lowercased().contains(lowercasedQuery) ||
                $0.text.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    func resetSearch() {
        searchText = ""
        KeyboardUtils.hideKeyboard()
        applySearch()
    }
    
}


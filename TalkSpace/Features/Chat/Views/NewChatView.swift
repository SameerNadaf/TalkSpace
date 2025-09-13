//
//  NewChatView.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI

struct NewChatView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = NewChatViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if viewModel.users.isEmpty {
                        EmptyStateView(fileName: "SearchEmpty.json", title: "No Contacts Found", subtitle: "The search did not match any contacts")
                    } else {
                        ForEach(viewModel.users) { user in
                            NavigationLink {
                                ChatView(chatUser: user)
                                    .onAppear {
                                        viewModel.resetSearch()
                                    }
                            } label: {
                                NewContactRow(user: user)
                                    .foregroundStyle(Color.primary)
                                    .padding(.top, 6)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            
            .searchable(text: $viewModel.searchText, placement: .automatic, prompt: "Search")
            .onChange(of: viewModel.searchText) {
                viewModel.applySearch()
            }
            
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    NewChatView()
}

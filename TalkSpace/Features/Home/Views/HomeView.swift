//
//  HomeView.swift
//  Message
//
//  Created by Sameer  on 09/09/25.
//

import SwiftUI
import Lottie

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var pressedMessage: RecentMessage? = nil
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                if viewModel.recentMessages.isEmpty {
                    EmptyStateView(fileName: "SearchEmpty.json", title: "No Recent Messages", subtitle: "Start a new conversation by tapping the pencil icon.")
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.recentMessages) { message in
                        ContactRowView(message: message)
                            .contentShape(Rectangle())
                            .scaleEffect(pressedMessage == message ? 0.95 : 1.0)
                            .opacity(pressedMessage == message ? 0.7 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: pressedMessage)
                            .onTapGesture {
                                viewModel.path.append(message)
                            }
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                withAnimation {
                                    pressedMessage = isPressing ? message : nil
                                }
                            }, perform: {
                                viewModel.selectedMessage = message
                                viewModel.showDeleteAlert = true
                                pressedMessage = nil
                            })
                            .onAppear {
                                viewModel.resetSearch()
                            }
                            .listRowSeparator(.hidden)
                    }
                }
            }

            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText, placement: .automatic, prompt: Text("Search"))
            .onChange(of: viewModel.searchText) {
                viewModel.applySearch()
            }
            
            .alert("Delete Chat?", isPresented: $viewModel.showDeleteAlert , presenting: viewModel.selectedMessage) { message in
                Button("DELETE", role: .destructive) {
                    Task {
                        if let msg = viewModel.selectedMessage {
                            await viewModel.deleteRecentChat(msg)
                        }
                    }

                }
                
                Button("CANCEL", role: .cancel) { }
                
            } message: { message in
                Text("Are you sure you want to delete your chat with \(message.userName)?")
            }
            
            .navigationDestination(for: RecentMessage.self) { message in
                ChatView(chatUser: ChatUser(
                    id: message.toId == AuthManager.shared.currentUser?.uid ? message.fromId : message.toId,
                    userName: message.userName,
                    email: "", // or fetch if needed
                    profileImageURL: message.profileImageURL
                ))
            }
            .navigationTitle("TalkSpace")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.openNewChat.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showActionSheet.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .confirmationDialog("Settings", isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
                Button("Edit Profile") {
                    viewModel.openProfile = true
                }
                
                Button("Log Out", role: .destructive) {
                    viewModel.logOut()
                    viewModel.isLogOutTapped = true
                }
            }
            .fullScreenCover(isPresented: $viewModel.openNewChat) {
                NewChatView()
            }
            .navigationDestination(isPresented: $viewModel.isLogOutTapped) {
                LoginView()
            }
            .sheet(isPresented: $viewModel.openProfile) {
                ProfileView()
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

#Preview {
    HomeView()
}


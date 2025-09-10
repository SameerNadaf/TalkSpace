//
//  HomeView.swift
//  Message
//
//  Created by Sameer  on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                ForEach(0..<20, id: \.self) { index in
                    ContactRowView()
                        .contentShape(Rectangle()) // Makes entire row tappable
                        .onTapGesture {
                            viewModel.path.append(index)
                        }
                        .listRowSeparator(.hidden)
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText, placement: .automatic, prompt: Text("Search"))
            
            .navigationDestination(for: Int.self) { index in
                Text("Hello, World for row \(index)")
            }
            
            .navigationTitle("TalkSpace")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
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
            
            // Action Sheet
            .confirmationDialog("Settings", isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
                Button("Edit Profile") {
                    
                }
                
                Button("Log Out", role: .destructive) {
                    viewModel.logOut()
                    viewModel.isLogOutTapped = true
                }
            }
            
            .navigationDestination(isPresented: $viewModel.isLogOutTapped) {
                LoginView()
            }
        }
    }
}

#Preview {
    HomeView()
}

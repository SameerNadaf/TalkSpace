//
//  ProfileView.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    userAvatarPicker
                        .padding(.bottom)
                    
                    Button {
                        viewModel.showEditName = true
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .font(.headline)
                                
                                Text("\(viewModel.userName)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundStyle(.primary)

                    
                    HStack {
                        Image(systemName: "mail")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.headline)
                            
                            Text("\(viewModel.email)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "quote.bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text("Quote")
                                .font(.headline)
                            
                            Text("\(viewModel.quote)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                }
            }
            .frame(maxWidth: 400)
            .padding(.horizontal, 30)
           
            .sheet(isPresented: $viewModel.showEditName) {
                EditNameView()
                    .presentationDetents([.medium, .large])
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                }
                
            }
        }
    }
}

extension ProfileView {
    
    private var userAvatarPicker: some View {
        VStack {
            if let avatar = viewModel.userAvatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: 4)
                    )
                    .padding()
            } else {
                Image("user")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: 4)
                    )
                    .padding()
            }
            
            PhotosPicker(selection: $viewModel.selectionImage, matching: .images) {
                Text("Edit")
                    .font(.headline)
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    ProfileView()
}

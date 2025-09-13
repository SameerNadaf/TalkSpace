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
                    userAvatar
                    imagePicker
                        .padding(.bottom)
                    
                    Button {
                        viewModel.showEditName = true
                    } label: {
                        ProfileDetailRow(iconName: "person.crop.circle", title: "Name", value: "\(viewModel.userName)")
                    }
                    .foregroundStyle(.primary)

                    ProfileDetailRow(iconName: "envelope", title: "Email", value: "\(viewModel.email)")
                    ProfileDetailRow(iconName: "info.circle", title: "About Me", value: "\(viewModel.bio)")
                }
            }
            .frame(maxWidth: 400)
            .padding(.horizontal, 30)
           
            .sheet(isPresented: $viewModel.showEditName) {
                EditNameView(viewModel: viewModel)
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
        .task {
            await viewModel.loadUserProfile()
        }
    }
}

extension ProfileView {
    
    private var userAvatar: some View {
        VStack {
            ZStack {
                RemoteImageView(
                    urlString: viewModel.avatarURL?.absoluteString,
                    size: 150
                )
                
                if viewModel.isAvatarBeingUpdated {
                    Color.black.opacity(0.4)
                        .clipShape(Circle())
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .clipShape(Circle())
            .frame(width: 150, height: 150)
            .overlay(
                Circle()
                    .stroke(Color.primary, lineWidth: 4)
            )
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var imagePicker: some View {
        PhotosPicker(selection: $viewModel.selectionImage, matching: .images) {
            Text("Edit")
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }

}

#Preview {
    ProfileView()
}

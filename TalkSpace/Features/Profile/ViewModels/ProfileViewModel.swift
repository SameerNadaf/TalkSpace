//
//  ProfileViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var bio: String = "Busy building something new..."
    
    @Published var showEditName: Bool = false
    @Published var name: String = "" {
        didSet {
            if name.count > 25 {
                name = String(name.prefix(25))
            }
        }
    }
    
    @Published var avatarURL: URL? = nil
    @Published var isAvatarBeingUpdated: Bool = false
    @Published var isLoadingProfile: Bool = false
    
    @Published var selectionImage: PhotosPickerItem? = nil {
        didSet {
            updateImage(from: selectionImage)
        }
    }
    
    private let profileService: ProfileServicable
    
    init (profileService: ProfileServicable = ProfileService()) {
        self.profileService = profileService
    }
    
    @MainActor
    func loadUserProfile() async {
        guard let userId = AuthManager.shared.currentUser?.uid else { return }
        
        isLoadingProfile = true
        
        do {
            let profile = try await profileService.fetchUserProfile(userId: userId)
            self.userName = profile.userName
            self.email = profile.email
            self.avatarURL = profile.profileImageURL
        } catch {
            print("Error loading user profile: \(error.localizedDescription)")
        }
        isLoadingProfile = false
    }
    
    private func updateImage(from selection: PhotosPickerItem?) {
        
        guard let selection else { return }
        
        Task {
            guard let data = try? await selection.loadTransferable(type: Data.self),
                  let userId = AuthManager.shared.currentUser?.uid else { return }
            
            await MainActor.run {
                self.isAvatarBeingUpdated = true
            }
            
            do {
                let imageURL = try await profileService.updateProfileImage(userId: userId, imageData: data)
                try await profileService.saveUserProfile(userId: userId, email: email, profileImageURL: imageURL)
            } catch {
                print("Error updating image: \(error.localizedDescription)")
            }
            
            await self.loadUserProfile()
            
            await MainActor.run {
                self.isAvatarBeingUpdated = false
            }
        }
    }
    
    @MainActor
    func updateUserName(completion: @escaping () -> Void) async {
        guard let userId = AuthManager.shared.currentUser?.uid else { return }
        
        do {
            if !name.isEmpty {
                try await profileService.updateUserName(userId: userId, userName: name)
                await loadUserProfile()
                print("Profile Name updated successfully")
                completion() // Call completion to close view
            } else {
                print("Please enter a valid name")
            }
        } catch {
            print("Error updating user name: \(error.localizedDescription)")
        }
    }
    
}


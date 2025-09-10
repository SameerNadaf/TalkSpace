//
//  RegisterViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import SwiftUI
import PhotosUI

final class RegisterViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var userAvatar: UIImage? = nil
    @Published var selectionImage: PhotosPickerItem? = nil {
        didSet {
            setImage(from: selectionImage)
        }
    }
    
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var isRegistered: Bool = false
    
    private let authService: AuthServicable
    
    init(authService: AuthServicable = AuthService()) {
        self.authService = authService
    }
    
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.userAvatar = uiImage
                }
            }
        }
    }
    
    @MainActor
    func registerUser() async -> Bool {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            showAlert = true
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showAlert = true
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let imageData = userAvatar?.jpegData(compressionQuality: 0.8)
            let result = try await authService.register(email: email, password: password, imageData: imageData)
            
            print("User ID: \(result.user.uid)")
            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("Error: \(error.localizedDescription)")
            showAlert = true
            return false
        }
    }

}

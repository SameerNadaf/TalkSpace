//
//  RegisterViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import SwiftUI
import PhotosUI

class RegisterViewModel: ObservableObject {
    
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
    
    private let firebaseManager: FirebaseManaging
    
    init(firebaseManager: FirebaseManaging = FirebaseManager.shared) {
        self.firebaseManager = firebaseManager
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
        
        do {
            let result = try await firebaseManager.createUserWithEmail(email: email, password: password)
            print("User ID: \(result.user.uid)")
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            showAlert = true
            return false
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

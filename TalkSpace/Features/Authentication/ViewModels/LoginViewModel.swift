//
//  LoginViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    
    private let authService: AuthServicable
    
    init(authService: AuthServicable = AuthService()) {
        self.authService = authService
    }
    
    @MainActor
    func loginUser() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            showAlert = true
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await authService.signIn(email: email, password: password)
            print("User logged in successfully: \(result.user.uid)")
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            showAlert = true
            return false
        }
    }
    
}

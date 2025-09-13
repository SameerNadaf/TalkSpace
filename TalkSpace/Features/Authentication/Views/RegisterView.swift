//
//  RegisterView.swift
//  TalkSpace
//
//  Created by Sameer  on 09/09/25.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Text("Register")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                        
                        userAvatarPicker
                        
                        IconTextField(systemImage: "envelope", placeholder: "Enter Email", text: $viewModel.email)
                        IconTextField(systemImage: "lock", placeholder: "Enter Password", text: $viewModel.password, isSecure: true)
                        IconTextField(systemImage: "lock", placeholder: "Confirm Password", text: $viewModel.confirmPassword)
                        ActionButton(title: "Sign Up") {
                            Task {
                                let success = await viewModel.registerUser()
                                if success {
                                    print("User registered successfully!")
                                    viewModel.isRegistered = true
                                }
                            }
                        }
                        OrDivider()
                        GoogleButton(title: "Sign Up with Google") {
                            
                        }
                        footerLink
                            .padding(.top)
                        
                    }
                    .padding(.horizontal, 40)
                    .frame(maxWidth: 500)
                }
                .onTapGesture {
                    KeyboardUtils.hideKeyboard()
                }
                
                // ProgressView overlay
                if viewModel.isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.isRegistered) {
                HomeView()
            }
            
        }
        .alert("Heyy!!!", isPresented: $viewModel.showAlert) {
            Button("OK") {
                
            }
        } message: {
            if let msg = viewModel.errorMessage {
                Text(msg)
            }
        }
        
    }
}

extension RegisterView {
    
    private var userAvatarPicker: some View {
        PhotosPicker(selection: $viewModel.selectionImage, matching: .images) {
            if let image = viewModel.userAvatar {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary, lineWidth: 4)
                        )
                        
                        
                } else {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle()
                                .stroke(Color.primary, lineWidth: 4)
                        )
                }
        }
        .padding()
    }
    
    private var footerLink: some View {
        HStack {
            Text("Already have an account?")
                .font(.subheadline)
            
            Button {
                dismiss()
            } label: {
                Text("Log In")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
    
}
#Preview {
    RegisterView()
}

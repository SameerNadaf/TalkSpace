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
                Color.clear
                    .contentShape(Rectangle()) // Make empty space tappable
                    .onTapGesture {
                        viewModel.hideKeyboard()
                    }
                
                VStack(spacing: 20) {
                    
                    Text("Register")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    
                    PhotosPicker(selection: $viewModel.selectionImage, matching: .images) {
                        if let image = viewModel.userAvatar {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 150, height: 150)
                            } else {
                                Image("user")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 150, height: 150)
                            }
                    }
                    .padding()
                    
                    
                    emailField
                    passwordField1
                    passwordField2
                    loginButton
                    orOption
                    googleButton
                    Spacer()
                    logInButton
                    
                }
                .padding(.horizontal, 40)
                .frame(maxWidth: 500)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension RegisterView {
    
    private var emailField: some View {
        HStack {
            Image(systemName: "at")
                .resizable()
                .scaledToFit()
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 20, height: 20)
                .padding(.trailing)
            
            VStack {
                TextField("Enter Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.none)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Email Address")
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var passwordField1: some View {
        HStack {
            Image(systemName: "lock")
                .resizable()
                .scaledToFit()
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 20, height: 20)
                .padding(.trailing)
            
            VStack {
                SecureField("Enter Password", text: $viewModel.password)
                    .textContentType(.password)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Password")
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var passwordField2: some View {
        HStack {
            Image(systemName: "lock")
                .resizable()
                .scaledToFit()
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 20, height: 20)
                .padding(.trailing)
            
            VStack {
                TextField("Confirm Password", text: $viewModel.confirmPassword)
                    .textContentType(.password)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Confirm Password")
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom)
    }
    
    private var loginButton: some View {
        Button {
            
        } label: {
            Text("Sign Up")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: StyleConstants.buttonHeight)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: StyleConstants.cornerRadius))
        }
    }
    
    private var orOption: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
            
            Text("OR")
            
            Rectangle()
                .frame(height: 1)
            
        }
        .foregroundColor(.secondary)
        .padding(.bottom)
    }
    
    private var googleButton: some View {
        Button {
            
        } label: {
            HStack {
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .font(.headline)
                Text("Login with Google")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: StyleConstants.buttonHeight)
            .background(.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: StyleConstants.cornerRadius))
        }
    }
    
    private var logInButton: some View {
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

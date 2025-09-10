//
//  LoginView.swift
//  TalkSpace
//
//  Created by Sameer  on 09/09/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle()) // Make empty space tappable
                    .onTapGesture {
                        viewModel.hideKeyboard()
                    }
                
                VStack(spacing: 20) {
                    
                    Image("logIn")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    
                    emailField
                    passwordField
                    loginButton
                    orOption
                    googleButton
                    Spacer()
                    signupButton
                    
                }
                .padding(.horizontal, 40)
                .frame(maxWidth: 500)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension LoginView {
    
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
    
    private var passwordField: some View {
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
        .padding(.bottom)
    }
    
    private var loginButton: some View {
        Button {
            
        } label: {
            Text("Login")
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
    
    private var signupButton: some View {
        HStack {
            Text("New to TalkSpace?")
                .font(.subheadline)
            
            NavigationLink(destination: RegisterView()) {
                Text("Sign Up")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        
    }
    
}

#Preview {
    LoginView()
}

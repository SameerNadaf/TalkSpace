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
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Image("logIn")
                            .resizable()
                            .scaledToFit()
                        
                        Text("LogIn")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                        
                        IconTextField(systemImage: "at", placeholder: "Enter Email", text: $viewModel.email)
                        IconTextField(systemImage: "lock", placeholder: "Enter Password", text: $viewModel.password, isSecure: true)
                        ActionButton(title: "LogIn") {
                            Task {
                                let success = await viewModel.loginUser()
                                if success {
                                    print("User logged in successfully")
                                    viewModel.isLoggedIn = true
                                }
                            }
                        }
                        OrDivider()
                        GoogleButton(title: "Login with Google") {
                            
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
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
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

extension LoginView {
    
    private var footerLink: some View {
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

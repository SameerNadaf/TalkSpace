//
//  EditNameView.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct EditNameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        Text("Edit Your Display Name")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                        
                        TextField("Enter Name", text: $viewModel.name)
                            .textInputAutocapitalization(.words)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: StyleConstants.cornerRadius))
                            .overlay {
                                RoundedRectangle(cornerRadius: StyleConstants.cornerRadius)
                                    .stroke(Color.primary, lineWidth: 2)
                            }
                            .padding(.bottom)
                        
                        Text("\(viewModel.name.count)/25")
                            .font(.subheadline)
                            .foregroundColor(viewModel.name.count >= 25 ? .red : .secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Text("People will see this name if you interact with them, keep it short and sweet!")
                    }
                    .padding()
                }
                .disabled(viewModel.isLoadingProfile) // Optionally disable interaction when loading
                .onTapGesture {
                    KeyboardUtils.hideKeyboard()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await viewModel.updateUserName {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        .font(.headline)
                        .disabled(viewModel.isLoadingProfile) // Disable save button when loading
                    }
                }
                
                // Overlay progress view
                if viewModel.isLoadingProfile {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    ProgressView()
                }
            }
        }
        
        .alert("Oops!", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel){ }
        } message: {
            if let msg = viewModel.errorMessage {
                Text(msg)
            }
        }
    }
}


#Preview {
    EditNameView(viewModel: ProfileViewModel())
}

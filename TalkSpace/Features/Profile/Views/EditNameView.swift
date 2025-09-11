//
//  EditNameView.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct EditNameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
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
                    
                    Text("People will see this name if you interact with them, keep it short and sweet!")
                        .font(.headline)
                }
            }
            .padding()
            .onTapGesture {
                KeyboardUtils.hideKeyboard()
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .font(.headline)
                    }
                }
                
            }
        }
    }
}

#Preview {
    EditNameView()
}

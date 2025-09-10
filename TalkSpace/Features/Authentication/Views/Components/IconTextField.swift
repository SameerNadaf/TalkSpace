//
//  IconTextField.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct IconTextField: View {
    var systemImage: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 20, height: 20)
                .padding(.trailing)
            
            VStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel(placeholder)
                } else {
                    TextField(placeholder, text: $text)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel(placeholder)
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    IconTextField(systemImage: "gear", placeholder: "Enter youe Email", text: $text)
}

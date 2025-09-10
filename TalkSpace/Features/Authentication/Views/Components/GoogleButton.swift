//
//  GoogleButton.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct GoogleButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .font(.headline)
                Text(title)
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
}

#Preview {
    GoogleButton(title: "SignIn with Google") {
        
    }
}

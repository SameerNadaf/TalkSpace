//
//  ActionButton.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    var color: Color = .blue
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: StyleConstants.buttonHeight)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: StyleConstants.cornerRadius))
        }
    }
}

#Preview {
    ActionButton(title: "gg") {
        
    }
}

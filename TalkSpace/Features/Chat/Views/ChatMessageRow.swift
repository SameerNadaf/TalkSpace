//
//  ChatMessageRow.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI

struct ChatMessageRow: View {
    let isCurrentUser: Bool
    let message: String
    let time: String
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message)
                    .padding(12)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 6)
            }
            
            if !isCurrentUser { Spacer() }
        }
    }
}

#Preview {
    VStack {
        ChatMessageRow(isCurrentUser: false, message: "Hello! How are you?", time: "10:30 AM")
        ChatMessageRow(isCurrentUser: true, message: "I'm doing great, thanks!", time: "10:31 AM")
    }
}


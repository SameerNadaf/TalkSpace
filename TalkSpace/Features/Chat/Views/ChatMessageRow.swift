//
//  ChatMessageRow.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatMessageRow: View {
    let isCurrentUser: Bool
    let message: String
    let imageURL: String?
    let time: String
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                
                VStack {
                    if let imageURL {
                        WebImage(url: URL(string: imageURL))
                            .resizable()
                            .indicator(.activity)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    if !message.isEmpty && message != "[Image]"{
                        Text(message)
                            .padding(.vertical, imageURL != nil ? 4 : 0)
                    }
                }
                .padding(imageURL != nil ? 4 : 12)
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
        .padding(.horizontal, 8)
    }
}


#Preview {
    VStack {
        ChatMessageRow(isCurrentUser: false, message: "Hello! How are you?", imageURL: "https://picsum.photos/300", time: "10:30 AM")
        ChatMessageRow(isCurrentUser: true, message: "I'm doing great, thanks!", imageURL: nil, time: "10:31 AM")
    }
}


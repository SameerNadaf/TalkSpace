//
//  NewContactRow.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI

struct NewContactRow: View {
    let user: ChatUser
    
    var body: some View {
        HStack(spacing: 20) {
            if let urlString = user.profileImageURL {
                RemoteImageView(
                    urlString: urlString,
                    size: 50
                )
            }
            
            VStack(alignment: .leading) {
                Text(user.userName)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    let user = ChatUser(id: "1", userName: "Sameer", email: "sameer@gmail.com", profileImageURL: "https://via.placeholder.com/150")
    NewContactRow(user: user)
}

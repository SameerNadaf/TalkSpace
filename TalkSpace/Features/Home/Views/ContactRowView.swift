//
//  ContactRowView.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI
import Firebase

struct ContactRowView: View {
    
    let message: RecentMessage
    @State private var currentDate = Date()
    
    var body: some View {
        HStack(alignment: .top) {
            
            RemoteImageView(urlString: message.profileImageURL, size: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.userName)
                    .font(.headline)
                
                Text(message.text)
                    .font(.subheadline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(message.timeAgo(relativeTo: currentDate))
                .font(.subheadline)
                .foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            startTimer()
        }
        
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            currentDate = Date()
        }
    }
}

#Preview {
//ContactRowView()
}

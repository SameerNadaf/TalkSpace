//
//  EmptyStateView.swift
//  TalkSpace
//
//  Created by Sameer  on 13/09/25.
//

import SwiftUI
import Lottie

struct EmptyStateView: View {
    let fileName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            LottieView(animation: .named(fileName))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
            
            Text(title)
                .font(.title3)
                .foregroundColor(.gray)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(fileName: "SearchEmpty.json", title: "No Data", subtitle: "this is an sample subtitle for empty state")
}

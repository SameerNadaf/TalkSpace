//
//  RemoteImageView.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RemoteImageView: View {
    let urlString: String?
    let placeholder: String
    let size: CGFloat
    
    init(urlString: String?,
         placeholder: String = "profile",
         size: CGFloat = 50) {
        self.urlString = urlString
        self.placeholder = placeholder
        self.size = size
    }
    
    var body: some View {
        ZStack {
            if let urlString, let url = URL(string: urlString) {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
            } else {
                Image(placeholder)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.primary, lineWidth: 1))
    }
}


#Preview {
    RemoteImageView(urlString: "https://picsum.photos/50")
}

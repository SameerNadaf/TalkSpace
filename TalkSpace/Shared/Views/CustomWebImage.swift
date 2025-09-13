//
//  CustomWebImage.swift
//  TalkSpace
//
//  Created by Sameer  on 13/09/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomWebImage: View {
    let imageURL: String
    let contentMode: ContentMode
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    
    init(imageURL: String,
         contentMode: ContentMode = .fill,
         width: CGFloat? = nil,
         height: CGFloat? = nil,
         cornerRadius: CGFloat = 0) {
        
        self.imageURL = imageURL
        self.contentMode = contentMode
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        WebImage(url: URL(string: imageURL))
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: contentMode)
            .frame(maxWidth: width, maxHeight: height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}


#Preview {
    CustomWebImage(imageURL: "https://picsum.photos/600", contentMode: .fit)
}

//
//  FullScreenImageView.swift
//  TalkSpace
//
//  Created by Sameer  on 13/09/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullScreenImageView: View {
    let imageURL: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            
            WebImage(url: URL(string: imageURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.gray)
                    .background(Material.ultraThick)
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}


#Preview {
    FullScreenImageView(imageURL: "https://picsum.photos/300", isPresented: .constant(true))
}

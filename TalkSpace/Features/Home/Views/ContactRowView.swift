//
//  ContactRowView.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct ContactRowView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.primary, lineWidth: 2)
                }
                .padding(.trailing, 6)
            
            VStack(alignment: .leading) {
                Text("Sameer Nadaf")
                    .font(.headline)
                
                Text("This is an example of a contact row with the name and a message which is multiline text and here it is limited to 2 lines")
                    .font(.subheadline)
                    .lineLimit(2)
            }
            
            Text("12:34 AM")
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContactRowView()
}

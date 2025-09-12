//
//  ProfileDetailRow.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import SwiftUI

struct ProfileDetailRow: View {
    let iconName: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProfileDetailRow(iconName: "envelope", title: "Email", value: "sameer@gmail.com")
}

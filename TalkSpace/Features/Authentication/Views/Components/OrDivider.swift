//
//  OrDivider.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

struct OrDivider: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
            Text("OR")
            Rectangle()
                .frame(height: 1)
        }
        .foregroundColor(.secondary)
        .padding(.bottom)
    }
}

#Preview {
    OrDivider()
}

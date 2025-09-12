//
//  Message.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import Foundation

struct Message: Identifiable {
    let id: String
    let text: String
    let fromId: String
    let toId: String
    let timestamp: Date
    let imageURL: String? 
}

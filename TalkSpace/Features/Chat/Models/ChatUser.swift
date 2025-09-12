//
//  ChatUser.swift
//  TalkSpace
//
//  Created by Sameer  on 11/09/25.
//

import Foundation

struct ChatUser: Identifiable, Hashable {
    let id: String
    let userName: String
    let email: String
    let profileImageURL: String?
}

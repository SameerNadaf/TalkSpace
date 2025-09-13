//
//  RecentMessage.swift
//  TalkSpace
//
//  Created by Sameer  on 12/09/25.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable, Hashable {
    let id: String
    let text: String
    let fromId: String
    let toId: String
    let profileImageURL: String
    let userName: String
    let timestamp: Date

    init(id: String, data: [String: Any]) {
        self.id = id
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        if let ts = data["timestamp"] as? Timestamp {
            self.timestamp = ts.dateValue()
        } else {
            self.timestamp = Date()
        }
    }

}

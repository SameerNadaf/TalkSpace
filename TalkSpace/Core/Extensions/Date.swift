//
//  Date.swift
//  TalkSpace
//
//  Created by Sameer  on 13/09/25.
//

import Foundation

extension Date {
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    func timeAgo(relativeTo date: Date = Date()) -> String {
        let elapsed = date.timeIntervalSince(self)
        
        if elapsed < 60 {
            return "Now"
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return formatter.localizedString(for: self, relativeTo: date)
        }
    }
}

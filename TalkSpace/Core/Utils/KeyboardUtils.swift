//
//  KeyboardUtils.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import UIKit

final class KeyboardUtils {
    
    /// Dismisses the keyboard for the entire app
    static func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

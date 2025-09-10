//
//  HomeService.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth

protocol HomeServicable {
    func signOut() throws
    func currentUser() -> User?
}

final class HomeService: HomeServicable {
    private let firebaseManager: FirebaseManagable
    
    init(firebaseManager: FirebaseManagable = FirebaseManager.shared) {
        self.firebaseManager = firebaseManager
    }
    
    func signOut() throws {
        try firebaseManager.signOut()
    }
    
    func currentUser() -> User? {
        firebaseManager.currentUser()
    }
}

//
//  AuthServicable.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import FirebaseAuth

protocol AuthServicable {
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func register(email: String, password: String, imageData: Data?) async throws -> AuthDataResult
}

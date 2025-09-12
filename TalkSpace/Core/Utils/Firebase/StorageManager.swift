//
//  StorageManager.swift
//  TalkSpace
//
//  Created by Sameer  on 12/09/25.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage()
    
    private init() {}
    
    func uploadProfileImage(userId: String, imageData: Data) async throws -> URL {
        let reference = storage.reference().child("profileImages/\(userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await reference.putDataAsync(imageData, metadata: metadata)
        return try await reference.downloadURL()
    }
}

//
//  StorageManager.swift
//  TalkSpace
//
//  Created by Sameer  on 12/09/25.
//

import Foundation
import SwiftUI
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
    
    func uploadChatImage(fromId: String, toId: String, image: UIImage) async throws -> URL {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "ChatImageUpload", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let uuid = UUID().uuidString
        let path = "chat_images/\(fromId)_\(toId)/\(uuid).jpg"
        let storageRef = Storage.storage().reference().child(path)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)

        let url = try await storageRef.downloadURL()
        return url
    }
    
}

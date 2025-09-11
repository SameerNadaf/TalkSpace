//
//  ProfileViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import Foundation
import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Sameer N"
    @Published var email: String = "sameer@gmail.com"
    @Published var quote: String = "Build something beautiful."
    @Published var showEditName: Bool = false
    @Published var name: String = ""
    
    @Published var userAvatar: UIImage? = nil
    @Published var selectionImage: PhotosPickerItem? = nil {
        didSet {
            setImage(from: selectionImage)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.userAvatar = uiImage
                }
            }
        }
    }
}

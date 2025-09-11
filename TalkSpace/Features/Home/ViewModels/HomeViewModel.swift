//
//  HomeViewModel.swift
//  TalkSpace
//
//  Created by Sameer  on 10/09/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var searchText: String = ""
    @Published var showActionSheet: Bool = false
    @Published var isLogOutTapped: Bool = false
    @Published var openProfile: Bool = false
    
    private let homeService: HomeServicable
    
    init (homeService: HomeServicable = HomeService()) {
        self.homeService = homeService
    }
    
    func logOut() {
        try? homeService.signOut()
    }
}

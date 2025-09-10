//
//  TalkSpaceApp.swift
//  TalkSpace
//
//  Created by Sameer  on 09/09/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TalkSpaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isUserLoggedIn = false
    @State private var isCheckingAuth = true
    
    var body: some Scene {
        WindowGroup {
            if isCheckingAuth {
                ProgressView("Loading...")
                    .onAppear {
                        // Safe to access Auth here because Firebase is configured
                        if Auth.auth().currentUser != nil {
                            isUserLoggedIn = true
                        }
                        isCheckingAuth = false
                    }
            } else {
                if isUserLoggedIn {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
    }
}

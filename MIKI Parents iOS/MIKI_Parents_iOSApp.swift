//
//  MIKI_Parents_iOSApp.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 03.09.24.
//

import SwiftUI
import FirebaseCore


import SwiftUI
import FirebaseFirestore

@main
struct MIKI_Parents_iOSApp: App {
    
    var body: some Scene {
        WindowGroup {
            if userViewModel.isUserSignedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .environment(userViewModel)
    }
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        userViewModel = UserViewModel()
    }
    
    private let userViewModel: UserViewModel

}

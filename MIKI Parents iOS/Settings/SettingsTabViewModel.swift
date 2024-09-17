//
//  SettingsTabViewModel.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import Foundation
import FirebaseAuth

class SettingsTabViewModel: ObservableObject {
    @Published var isLoggedOut = false
    @Published var errorMessage: String?

    // Methode zum Ausloggen
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true // Erfolgreiches Logout
        } catch let signOutError as NSError {
            errorMessage = "Error signing out: \(signOutError.localizedDescription)"
        }
    }
}

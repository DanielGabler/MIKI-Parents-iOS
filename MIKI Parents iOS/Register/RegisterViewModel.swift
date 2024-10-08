//
//  RegisterViewModel.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import FirebaseAuth
import Combine

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var registerSuccess = false
    @Published var errorMessage: String?
    
    func register() {
        Task{
            do {
                try await FirebaseAuthManager.shared.signUp(email: email, password: password)
            } catch {
                print("Error signing up: \(error.localizedDescription)")
                
                
            }
        }
    }
}

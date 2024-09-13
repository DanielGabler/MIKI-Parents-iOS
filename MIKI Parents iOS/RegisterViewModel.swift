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
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.registerSuccess = true  // Erfolgreiche Registrierung
            }
        }
    }
}

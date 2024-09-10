//
//  LoginViewModel.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var loginSuccess = false
    @Published var errorMessage: String?

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.loginSuccess = true
            }
        }
    }
}

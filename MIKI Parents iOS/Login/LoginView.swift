//
//  LoginView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var loginSuccess = false
    @State var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Textfelder für Email und Passwort
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Login Button
                Button("Login") {
                    attemptSignIn()
                }
                .padding()
                
                // Fehlermeldung anzeigen
                
                
                
                
                // Button zur Registrierung
                VStack {
                    Text("Noch keinen Account?")
                    NavigationLink(destination: RegisterView()) {
                        Text("Jetzt registrieren")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 20)
                
            }
            .padding()
            .navigationTitle("MIKI Parents iOS")
        }
    }
    private func attemptSignIn() {
        Task {
            do {
                try await userViewModel.signIn(email: email, password: password)
            } catch {
                print("Error")
            }
        }
    }
    @Environment(UserViewModel.self) private var userViewModel
}




#Preview {
    LoginView()
}

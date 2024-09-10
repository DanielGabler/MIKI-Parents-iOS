//
//  LoginView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Textfelder für Email und Passwort
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Login Button
                Button("Login") {
                    viewModel.login()
                }
                .padding()

                // Fehlermeldung anzeigen
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                // Navigation zu HomeView bei erfolgreichem Login
                NavigationLink(destination: HomeView(), isActive: $viewModel.loginSuccess) {
                    EmptyView()
                }
                .padding()
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
}


#Preview {
    LoginView()
}

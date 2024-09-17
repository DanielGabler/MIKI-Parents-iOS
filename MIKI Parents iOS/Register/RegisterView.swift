//
//  RegisterView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        VStack {
            // Textfelder für Email und Passwort
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Register Button
            Button("Register") {
                viewModel.register()
            }
            .padding()

            // Fehlermeldung anzeigen, falls vorhanden
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            // Navigation zu HomeView bei erfolgreicher Registrierung
            NavigationLink(destination: HomeView(), isActive: $viewModel.registerSuccess) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Register")
    }
}

#Preview {
    RegisterView()
}

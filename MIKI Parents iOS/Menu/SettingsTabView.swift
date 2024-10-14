//
//  SettingsTab.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import SwiftUI
import FirebaseAuth

struct SettingsTabView: View {
    @StateObject private var viewModel = SettingsTabViewModel()
    
    // Benutzerinformationen
    @State private var displayName: String = "Benutzer" // Standardname für den Benutzer

    var body: some View {
        VStack {
            Spacer()

            // Logo
            Image("logo") // Stelle sicher, dass der Name des Bilds "logo.png" korrekt ist
                .resizable()
                .cornerRadius(24)
                .scaledToFit()
                .frame(width: 150, height: 150) // Größe des Logos
                .padding(.bottom, 40) // Abstand zwischen Logo und den Eingabefeldern

            // Begrüßungstext mit dem Benutzernamen oder der E-Mail
            Text("Angemeldet als \(displayName)")
                .font(.title2)
                .padding(.bottom, 20) // Abstand zwischen dem Namen und dem Logout-Button
            
            // Fehlermeldung, falls Logout fehlschlägt
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // Logout Button
            Button(action: {
                FirebaseAuthManager.shared.signOut()
            }) {
                Text("Logout")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }

            Spacer()

        }
        .onAppear {
            // Beim Laden der View Benutzerinformationen abrufen
            fetchUserDetails()
        }
        .navigationTitle("Einstellungen")
    }
    
    private func fetchUserDetails() {
        // Aktuellen Benutzer abrufen
        if let user = Auth.auth().currentUser {
            // Versuche zuerst, den Anzeigenamen zu holen
            if let name = user.displayName {
                displayName = name
            } else if let email = user.email {
                // Falls kein Anzeigename vorhanden ist, zeige die E-Mail an
                displayName = email
            }
        }
    }
}

#Preview {
    SettingsTabView()
}

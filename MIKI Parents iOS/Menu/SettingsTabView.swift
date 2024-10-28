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
    @AppStorage("isDarkMode") private var isDarkMode = false // AppStorage für den Dark-/Light-Modus

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // Logo
                Image("logo") // Stelle sicher, dass der Name des Bilds "logo.png" korrekt ist
                    .resizable()
                    .cornerRadius(24)
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Größe des Logos
                    .padding(.bottom, 10) // Weniger Abstand unterhalb des Logos
                
                // Dark-/Light-Modus Umschalter unter dem Logo
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                    .onChange(of: isDarkMode) { _ in
                        // Update der Farbgebung direkt bei Änderung
                    }

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

                // Family Manager Button
                NavigationLink(destination: FamilyManagerView()) {
                    Text("Family Manager")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
            .preferredColorScheme(isDarkMode ? .dark : .light) // Anpassung des Modus
        }
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

//
//  LoginView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import AVFoundation

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var loginSuccess = false
    @State var errorMessage: String?
    
    // State für die Logo-Animation
    @State private var logoOffset: CGFloat = -UIScreen.main.bounds.height / 2 // Startpunkt außerhalb des Bildschirms
    
    var body: some View {
        NavigationStack {
            VStack {
                // Logo-Bild mit Animation
                Image("logo") // Stelle sicher, dass der Name des Bilds "logo.png" korrekt ist
                    .resizable()
                    .cornerRadius(24)
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Größe des Logos
                    .offset(y: logoOffset) // Offset für die Animation
                    .onAppear {
                        // Animation beim Starten der Seite
                        withAnimation(.easeOut(duration: 1.5)) {
                            logoOffset = 0 // Zielpunkt: oberhalb der Eingabefelder
                        }
                        // Sound abspielen
                        AudioPlayer.shared.playSound(soundFileName: "kids_laugh")
                    }
                    .padding(.bottom, 40) // Abstand zwischen Logo und den Eingabefeldern
                
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
            .navigationTitle("MIKI Parents")
        }
    }
    
    private func attemptSignIn() {
        Task {
            do {
                try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            } catch {
                print("Error")
            }
        }
    }
}

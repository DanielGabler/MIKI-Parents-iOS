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
    @State private var isShowingScanner = false
    @State private var scannedCode: String = ""
    @State private var logoOffset: CGFloat = -UIScreen.main.bounds.height / 2

    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .cornerRadius(24)
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .offset(y: logoOffset)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            logoOffset = 0
                        }
                        AudioPlayer.shared.playSound(soundFileName: "kids_laugh")
                    }
                    .padding(.bottom, 40)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Passwort", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Login Button mit Umrandung
                Button(action: {
                    attemptSignIn()
                }) {
                    Text("Anmelden")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // Button über die gesamte Breite
                        .background(Color.blue) // Hintergrundfarbe
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 2) // Umrandung
                        )
                }
                .padding(.bottom, 20) // Abstand zum nächsten Element
                
                // QR-Code Scanner Button mit Bild hinzufügen
                Button(action: {
                    isShowingScanner = true
                }) {
                    HStack {
                        Text("QR-Scan")
                            .font(.subheadline)
                            .foregroundColor(.blue)

                        // QR-Icon Bild hinzufügen
                        Image("qr_icon") // Stelle sicher, dass "qr_icon" im Asset-Katalog vorhanden ist
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) // Größe des Icons
                            .padding(.leading, 5) // Abstand zwischen Text und Icon
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
                }
                .sheet(isPresented: $isShowingScanner) {
                    QRCodeScannerView(scannedCode: $scannedCode)
                        .onChange(of: scannedCode) { _, newCode in
                            parseScannedCode(newCode)
                        }
                }

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

    private func parseScannedCode(_ code: String) {
        let components = code.split(separator: ",")
        if components.count >= 1 {
            // Extrahiere die E-Mail und ignoriere das Passwort
            let emailComponent = components[0].replacingOccurrences(of: "email: ", with: "").trimmingCharacters(in: .whitespaces)
            self.email = emailComponent
            
            // Schließe das Kamera-Sheet
            isShowingScanner = false
        }
    }
}

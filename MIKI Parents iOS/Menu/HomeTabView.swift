//
//  Page1View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI
import FirebaseAuth

struct HomeTabView: View {
    @State private var displayedText = ""
    private var fullText: String {
        if let displayName = Auth.auth().currentUser?.displayName {
            return "Herzlich Willkommen, \(displayName) bei\nMIKI Parents iOS"
        } else if let email = Auth.auth().currentUser?.email {
            return "Herzlich Willkommen, \(email) bei\nMIKI Parents iOS"
        } else {
            return "Herzlich Willkommen bei\nMIKI Parents iOS"
        }
    }
    @State private var charIndex = 0
    @State private var timer: Timer?
    
    // State für das Logo
    @State private var logoOpacity = 0.0 // Startet unsichtbar
    
    var body: some View {
        VStack {
            // Logo, das langsam eingeblendet wird
            Image("logo")
                .resizable()
                .cornerRadius(24) // Abgerundete Ecken
                .scaledToFit()
                .frame(width: 150, height: 150) // Größe des Logos
                .opacity(logoOpacity) // Kontrolliere die Sichtbarkeit
                .padding(.bottom, 40) // Abstand zum Text

            // Begrüßungstext
            Text(displayedText)
                .font(.title) // Style der Schrift
                .multilineTextAlignment(.center) // Mittig
                .padding()
                .onAppear {
                    startTypingAnimation() // Startet die Tippen-Animation
                }
        }
    }
    
    private func startTypingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText.append(fullText[index]) // Füge das nächste Zeichen hinzu
                charIndex += 1
            } else {
                timer?.invalidate()
                timer = nil
                
                // Sobald der Text vollständig ist, Logo langsam einblenden
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 1.5)) {
                        logoOpacity = 1.0 // Logo einblenden
                    }
                }
            }
        }
    }
}

#Preview {
    HomeTabView()
}

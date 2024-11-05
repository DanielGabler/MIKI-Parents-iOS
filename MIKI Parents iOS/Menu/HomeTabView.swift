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
            return "Herzlich Willkommen,\n \(displayName) bei\nMIKI Parents iOS"
        } else if let email = Auth.auth().currentUser?.email {
            return "Herzlich Willkommen,\n \(email) bei\nMIKI Parents iOS"
        } else {
            return "Herzlich Willkommen bei\nMIKI Parents iOS"
        }
    }
    @State private var charIndex = 0
    @State private var timer: Timer?
    
    // State für das Logo
    @State private var logoOpacity = 0.0 // Startet unsichtbar
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo oben auf dem Bildschirm
                Image("logo")
                    .resizable()
                    .cornerRadius(24)
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .opacity(logoOpacity)
                    .padding(.top, 40)
                
                Spacer() // Fügt flexiblen Abstand zwischen Logo und Text hinzu
                
                // Begrüßungstext unterhalb des Logos
                Text(displayedText)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal) // Seitenabstand
                    .padding(.top, 20) // zusätzlicher Abstand zum Logo
                    .onAppear {
                        startTypingAnimation()
                    }
                
                Spacer() // Platzhalter für den Text, der ihn in der Mitte hält
            }
            .navigationTitle("MIKI Parents")
        }
    }
    
    private func startTypingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText.append(fullText[index])
                charIndex += 1
            } else {
                timer?.invalidate()
                timer = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 1.5)) {
                        logoOpacity = 1.0
                    }
                }
            }
        }
    }
}

#Preview {
    HomeTabView()
}

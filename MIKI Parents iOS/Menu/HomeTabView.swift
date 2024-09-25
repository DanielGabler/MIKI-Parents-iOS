//
//  Page1View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

struct HomeTabView: View {
    @State private var displayedText = "" // Der aktuell angezeigte Text
    private let fullText = "Herzlich Willkommen bei\nMIKI Parents iOS" // Voller Begrüßungstext
    @State private var charIndex = 0 // Aktueller Zeichenindex
    @State private var timer: Timer? // Timer für die Animation
    
    var body: some View {
        VStack {
            Text(displayedText) // Zeigt den animierten Text an
                .font(.title) // Schriftgröße
                .multilineTextAlignment(.center) // Zentrierte Ausrichtung
                .padding()
                .onAppear {
                    startTypingAnimation()
                }
        }
    }
    
    // Funktion, um die Animation zu starten
    private func startTypingAnimation() {
        // Timer erstellen, der alle 0.1 Sekunden ein weiteres Zeichen anzeigt
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText.append(fullText[index]) // Füge das nächste Zeichen hinzu
                charIndex += 1
            } else {
                // Stoppe den Timer, wenn der gesamte Text angezeigt wurde
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

#Preview {
    HomeTabView()
}

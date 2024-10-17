//
//  FamilyJoinView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 15.10.24.
//

import SwiftUI

struct FamilyJoinView: View {
    // Verbindet sich mit der State-Variable für den eingegebenen Code
    @State private var familyCode: String = "" // Eine State-Variable für den Familiencode

    var body: some View {
        VStack {
            Text("Familie beitreten")
                .font(.largeTitle)
                .padding()

            // Textfeld für den Benutzer zur Eingabe des Familiencodes
            TextField("Familiencode eingeben", text: $familyCode) // Hier wird die Binding-Variable korrekt verwendet
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Button zur Bestätigung der Eingabe
            Button(action: {
                // Aktion zum Beitreten der Familie mit dem eingegebenen Code
                joinFamily()
            }) {
                Text("Familie beitreten")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
    }

    // Funktion zum Beitreten der Familie
    private func joinFamily() {
        // Hier kannst du die Logik implementieren, um den Familiencode zu überprüfen und der Familie beizutreten
        print("Beitreten mit Code: \(familyCode)")
    }
}

#Preview {
    FamilyJoinView()
}

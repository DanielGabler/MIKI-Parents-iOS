//
//  SettingsTab.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var viewModel = SettingsTabViewModel()
    

    var body: some View {
        VStack {
            Spacer()

            // Fehlermeldung, falls Logout fehlschlägt
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // Logout Button
            Button(action: {
                userViewModel.signOut()
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
        .navigationTitle("Einstellungen")
    }
    @Environment(UserViewModel.self) private var userViewModel
}

#Preview {
    SettingsTabView()
}

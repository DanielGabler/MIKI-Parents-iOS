//
//  FullscreenView2.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 23.09.24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct FullscreenView: View {
    let imageUrl: URL
    let uploadDate: Timestamp?

    var body: some View {
        VStack {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            } placeholder: {
                ProgressView()
            }
        }
    }
}

// Date-Formatter für die Anzeige des Datums
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

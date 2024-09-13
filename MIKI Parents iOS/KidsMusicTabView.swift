//
//  Page4View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

struct KidsMusicTabView: View {
    @StateObject private var viewModel = KidsMusicViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(viewModel.musicItems) { item in
                    NavigationLink(destination: KidsMusicDetailView(musicItem: item)) {
                        HStack {
                            // Lade das Bild aus der URL
                            AsyncImage(url: URL(string: item.artworkUrl100)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                            }

                            VStack(alignment: .leading) {
                                Text(item.trackName)
                                    .font(.headline)
                                Text(item.artistName)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Kids Music")
            .onAppear {
                viewModel.fetchKidsMusic()
            }
        }
    }
}

#Preview {
    KidsMusicTabView()
}

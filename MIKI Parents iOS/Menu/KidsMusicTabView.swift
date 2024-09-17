//
//  Page4View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

struct KidsMusicTabView: View {
    @StateObject private var viewModel = KidsMusicViewModel()
    @State private var selectedTrack: KidsMusicItem?

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if viewModel.tracks.isEmpty {
                    Text("No tracks available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.tracks) { track in
                        Button(action: {
                            selectedTrack = track // Track für die Detailansicht setzen
                        }) {
                            HStack {
                                // Coverbild des Tracks anzeigen
                                if let artworkUrl = track.artworkUrl100, let url = URL(string: artworkUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    }
                                }

                                // Trackname und Künstler anzeigen
                                VStack(alignment: .leading) {
                                    Text(track.trackName)
                                        .font(.headline)
                                    Text(track.artistName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .sheet(item: $selectedTrack) { track in
                        // Navigation zur Detailansicht mit dem ausgewählten Track
                        KidsMusicDetailView(musicItem: track)
                    }
                }

                Button(action: {
                    viewModel.fetchRandomTracks() // Button zum Neuladen der Tracks
                }) {
                    Text("Neue Liste anzeigen")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Musik")
            .onAppear {
                viewModel.fetchRandomTracks()
            }
        }
    }
}

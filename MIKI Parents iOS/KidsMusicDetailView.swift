//
//  KidsMusicDetailView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import SwiftUI
import AVFoundation

struct KidsMusicDetailView: View {
    let musicItem: KidsMusicItem
    
    // AVPlayer für die Audio-Vorschau
    @State private var player: AVPlayer?
    @State private var isPlaying = false

    var body: some View {
        VStack(spacing: 20) {
            // Album Artwork
            AsyncImage(url: URL(string: musicItem.artworkUrl100)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }

            // Track Name und Künstler
            Text(musicItem.trackName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(musicItem.artistName)
                .font(.title2)
                .foregroundColor(.gray)

            // Album Name
            Text("From Album: \(musicItem.collectionName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            // Vorschau Button: Abspielen/Pausieren
            if let previewUrl = musicItem.previewUrl, let url = URL(string: previewUrl) {
                VStack {
                    Button(action: {
                        if isPlaying {
                            pausePreview()
                        } else {
                            playPreview(url: url)
                        }
                    }) {
                        Text(isPlaying ? "Pause Preview" : "Play Preview")
                            .font(.headline)
                            .padding()
                            .background(isPlaying ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                Text("No Preview Available")
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(musicItem.trackName)
        .onDisappear {
            // Stoppe den Player, wenn die Ansicht verlassen wird
            stopPreview()
        }
    }

    // Funktion zum Abspielen der Vorschau
    private func playPreview(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }

    // Funktion zum Pausieren der Vorschau
    private func pausePreview() {
        player?.pause()
        isPlaying = false
    }

    // Funktion zum Stoppen der Vorschau
    private func stopPreview() {
        player?.pause()
        player = nil
        isPlaying = false
    }
}

//#Preview {
//    KidsMusicDetailView(musicItem: KidsMusicItem)
//}

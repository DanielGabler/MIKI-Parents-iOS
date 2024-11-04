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
    @Environment(\.dismiss) private var dismiss // Umgebung zum Schließen des Sheets

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Album Artwork
                    AsyncImage(url: URL(string: musicItem.artworkUrl100!)) { image in
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
                    Text("Album: \(musicItem.collectionName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Veröffentlichungsdatum
                    if let releaseDate = musicItem.releaseDate {
                        Text("Veröffentlicht am: \(formatDate(releaseDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Genre
                    if let genre = musicItem.primaryGenreName {
                        Text("Genre: \(genre)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Preis
                    if let price = musicItem.trackPrice, let currency = musicItem.currency {
                        Text("Preis: \(String(format: "%.2f", price)) \(currency)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

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
                                Text(isPlaying ? "Vorschau Stoppen" : "Vorschau Starten")
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

                    // Links zu iTunes, Spotify und YouTube
                    VStack(spacing: 20) {
                        // YouTube Link
                        if let youtubeUrl = createYouTubeUrl(trackName: musicItem.trackName, artistName: musicItem.artistName) {
                            Link("Auf YouTube Abspielen", destination: youtubeUrl)
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // iTunes Link
                        if let iTunesUrl = musicItem.trackViewUrl, let url = URL(string: iTunesUrl) {
                            Link("Bei iTunes Kaufen", destination: url)
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle(musicItem.trackName)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Schließen") {
                            dismiss() // Sheet schließen
                        }
                    }
                }
                .onDisappear {
                    // Stoppe den Player, wenn die Ansicht verlassen wird
                    stopPreview()
                }
            }
            .scrollIndicators(.hidden) // Scrollbalken ausblenden
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

    // Funktion zum Formatieren des Veröffentlichungsdatums
    private func formatDate(_ date: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: date) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return date
    }
    
    // Funktion zum Erstellen des YouTube-Suchlinks
    private func createYouTubeUrl(trackName: String, artistName: String) -> URL? {
        let searchQuery = "\(trackName) \(artistName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return URL(string: "https://www.youtube.com/results?search_query=\(searchQuery ?? "")")
    }
}

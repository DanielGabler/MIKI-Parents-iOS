//
//  KidsMusicViewModel.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import Foundation

class KidsMusicViewModel: ObservableObject {
    @Published var tracks = [KidsMusicItem]()
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false // Variable für den Ladezustand

    func fetchRandomTracks() {
        isLoading = true // Setzt den Ladezustand auf true, wenn die Anfrage gestartet wird
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=kinder+musik&media=music&entity=song&limit=200") else {
            self.errorMessage = "Invalid URL"
            isLoading = false // Setzt den Ladezustand zurück
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching data: \(error.localizedDescription)"
                    self.isLoading = false // Setzt den Ladezustand zurück
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                    self.isLoading = false // Setzt den Ladezustand zurück
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                
                // Zufälliges Mischen der Tracks
                let shuffledTracks = result.results.shuffled()

                DispatchQueue.main.async {
                    self.tracks = shuffledTracks
                    self.isLoading = false // Setzt den Ladezustand zurück
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding data: \(error.localizedDescription)"
                    self.isLoading = false // Setzt den Ladezustand zurück
                }
            }
        }
        task.resume()
    }
}

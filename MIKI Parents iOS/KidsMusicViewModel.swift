//
//  KidsMusicViewModel.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import Foundation

class KidsMusicViewModel: ObservableObject {
    @Published var musicItems: [KidsMusicItem] = []
    @Published var errorMessage: String?

    func fetchKidsMusic() {
        let urlString = "https://itunes.apple.com/search?term=kids+music&media=music&entity=song&limit=100"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data returned"
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(iTunesSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.musicItems = decodedResponse.results
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}

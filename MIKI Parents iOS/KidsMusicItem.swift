//
//  KidsMusicItem.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

import Foundation

struct KidsMusicItem: Identifiable, Codable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    let collectionName: String
    let previewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl100
        case collectionName
        case previewUrl
    }
}

struct iTunesSearchResponse: Codable {
    let results: [KidsMusicItem]
}

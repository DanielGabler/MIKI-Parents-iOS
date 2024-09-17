//
//  KidsMusicItem.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 13.09.24.
//

struct SearchResult: Codable {
    let results: [KidsMusicItem]
}


import Foundation

struct KidsMusicItem: Identifiable, Codable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String?
    let collectionName: String
    let previewUrl: String?
    let trackViewUrl: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let trackPrice: Double?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl100
        case collectionName
        case previewUrl
        case trackViewUrl
        case releaseDate
        case primaryGenreName
        case trackPrice
        case currency
    }
}


struct iTunesSearchResponse: Codable {
    let results: [KidsMusicItem]
}

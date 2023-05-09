//
//  Game.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 06/05/23.
//

import Foundation
// MARK: - Game
struct Game: Codable {
    let id: Int
    let cover: Cover
    let createdAt: Int
    let firstReleaseDate: Int?
    let genres: [IGDB_Item]?
    let name: String
    let releaseDates: [Int]
    let summary: String?
    let totalRating: Double?
    let totalRatingCount: Int?
    let updatedAt: Int
    let url: String
    let checksum: String
    let ageRatings: [Int]?
    let collection: IGDB_Item?
    let status: Int?
    let storyline: String?

    enum CodingKeys: String, CodingKey {
        case id, cover
        case createdAt = "created_at"
        case firstReleaseDate = "first_release_date"
        case genres, name
        case releaseDates = "release_dates"
        case summary
        case totalRating = "total_rating"
        case totalRatingCount = "total_rating_count"
        case updatedAt = "updated_at"
        case url, checksum
        case ageRatings = "age_ratings"
        case collection, status, storyline
    }
}

/*
// MARK: - Game
struct Game: Codable {
    let id: Int
    let ageRatings, artworks: [Int]
    let category, cover, createdAt: Int
    let externalGames: [Int]
    let firstReleaseDate: Int
    let gameModes, genres: [Int]
    let name: String
    let platforms, releaseDates, screenshots, similarGames: [Int]
    let slug, summary: String
    let tags, themes: [Int]
    let updatedAt: Int
    let url: String
    let checksum: String
    let languageSupports: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case ageRatings = "age_ratings"
        case artworks, category, cover
        case createdAt = "created_at"
        case externalGames = "external_games"
        case firstReleaseDate = "first_release_date"
        case gameModes = "game_modes"
        case genres, name, platforms
        case releaseDates = "release_dates"
        case screenshots
        case similarGames = "similar_games"
        case slug, summary, tags, themes
        case updatedAt = "updated_at"
        case url, checksum
        case languageSupports = "language_supports"
    }
}
*/

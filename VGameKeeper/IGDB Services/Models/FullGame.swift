//
//  FullGame.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import Foundation

// MARK: - FullGameElement
struct FullGame: Codable {
    let id: Int
    let ageRatings: [AgeRating_IGDB]?
    let category: Int?
    let collection: IGDB_Item?
    let cover: Cover?
    let firstReleaseDate, follows: Int?
    let gameModes, genres: [IGDB_Item]?
    let hypes: Int?
    let involvedCompanies: [InvolvedCompany]?
    let name: String
    let platforms: [Platform]?
    let playerPerspectives: [IGDB_Item]?
    let screenshots: [Cover]?
    let similarGames: [SimilarGame]?
    let slug, storyline, summary: String?
    let themes: [IGDB_Item]?
    let totalRating: Double?
    let totalRatingCount: Int?
    let url: String

    enum CodingKeys: String, CodingKey {
        case id
        case ageRatings = "age_ratings"
        case category, collection, cover
        case firstReleaseDate = "first_release_date"
        case follows
        case gameModes = "game_modes"
        case genres, hypes, name, platforms
        case involvedCompanies = "involved_companies"
        case playerPerspectives = "player_perspectives"
        case screenshots
        case similarGames = "similar_games"
        case slug, storyline, summary, themes
        case totalRating = "total_rating"
        case totalRatingCount = "total_rating_count"
        case url
    }
}

// MARK: - AgeRating
struct AgeRating_IGDB: Codable {
    let id, category, rating: Int
}

// MARK: - SimilarGame
struct SimilarGame: Codable {
    let id: Int
    let cover: Cover?
    let name: String
}

typealias FullGameList = [FullGame]

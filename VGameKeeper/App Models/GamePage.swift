//
//  SingleGame.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import Foundation

struct GamePage: Identifiable {
    var id: UUID = UUID()
    var ageRatings: [AgeRate_Game]?
    var category: Game_Category?
    var collection: String = ""
    var coverUrl: String = ""
    var externalPageUrl: String = ""
    var gameModes, genres: [String]?
    var firstRelease: Date?
    var follows: Int = 0
    var hypes: Int = 0
    var name: String = ""
    var platforms, playerPerspectives: [String]?
    var similarGames: [FeaturedGame]?
    var screenshots: [String]?
    var slug, storyline, summary: String?
    var themes: [String]?
    var totalRating: Double?
    var totalRatingCount: Int?
}

struct AgeRate_Game {
    var rating: Int
    var category: Int
}

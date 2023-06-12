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
    var companies: [String: [String]]?
    var platforms, playerPerspectives: [String]?
    var similarGames: [FeaturedGame]?
    var screenshots: [String]?
    var slug, storyline, summary: String?
    var themes: [String]?
    var totalRating: Double?
    var totalRatingCount: Int?
    
    static let COMPANY_DEVLOPERS_KEY = "developers"
    static let COMPANY_PUBLISHER_KEY = "publishers"
    static let COMPANY_SUPPORTING_KEY = "supporting"
}

struct AgeRate_Game {
    var rating: Int
    var category: Int
}

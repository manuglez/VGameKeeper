//
//  GameDetailViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import Foundation

class GameDetailViewModel {
    var gameInfo: GamePage?
    
    func fetchGameFullInfo(gameID: Int, completion : @escaping () -> ()){
        Task {
            if let gameResponse = try await IGDBGameQuery.shared.singleGame(byId: gameID) {
                gameInfo = seviceGameToAppGameInfo(serviceGameInfo: gameResponse)
            }
            completion()
        }
    }
    
    func seviceGameToAppGameInfo(serviceGameInfo: FullGame) -> GamePage {
        var game = GamePage()
        game.ageRatings = serviceGameInfo.ageRatings?.map{
            AgeRate_Game(rating: $0.rating, category: $0.category)
        }
        game.category = Game_Category(rawValue: serviceGameInfo.category ?? 0)
        if let serviceCollection = serviceGameInfo.collection {
            game.collection = serviceCollection.name
        }
        
        if let serviceCover = serviceGameInfo.cover {
            game.coverUrl = serviceCover.url
        }
        game.externalPageUrl = serviceGameInfo.url
        
        game.gameModes = serviceGameInfo.gameModes?.map { $0.name }
        
        game.genres = serviceGameInfo.genres?.map { $0.name }
        
        if let serviceDate = serviceGameInfo.firstReleaseDate {
            game.firstRelease = Date(timeIntervalSince1970: TimeInterval(serviceDate))
        }
        
        game.follows = serviceGameInfo.follows ?? 0
        game.hypes = serviceGameInfo.hypes ?? 0
        game.name = serviceGameInfo.name
        
        game.platforms = serviceGameInfo.platforms?.map { $0.name }
        
        game.playerPerspectives = serviceGameInfo.playerPerspectives?.map { $0.name }
        
        game.similarGames = serviceGameInfo.similarGames?.map {
            FeaturedGame(id: UUID(), dbIdentifier: $0.id, name: $0.name, imageUrl: $0.cover?.url ?? "" )
        }
        
        game.screenshots = serviceGameInfo.screenshots?.map { $0.url }
        
        game.slug = serviceGameInfo.slug ?? ""
        
        game.storyline = serviceGameInfo.storyline ?? ""
        
        game.summary = serviceGameInfo.summary ?? ""
        
        game.themes = serviceGameInfo.themes?.map { $0.name }
        
        game.totalRating = serviceGameInfo.totalRating ?? 0
        
        game.totalRatingCount = serviceGameInfo.totalRatingCount ?? 0
        
        return game
    }
    
    func itemArrayToStringArray(originalArray: [IGDB_Item]) -> [String] {
        var stringArray: [String] = []
        for item in originalArray {
            stringArray.append(item.name)
        }
        return stringArray
    }
}

//
//  IGDBGameQuery.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 05/05/23.
//

import Foundation

enum Query_Endpoints: String {
    case games = "games"
    case releaseDates = "release_dates"
    case covers = "covers"
    case platforms = "platforms"
    case search = "search"
    case screenshot = "screenshots"

}

class IGDBGameQuery {
    // Singleton global instance
    static let shared: IGDBGameQuery = IGDBGameQuery()
    
    /*private let GAME_FIELDS =  " game.age_ratings,game.checksum,game.collection.name,game.cover.url,game.created_at,game.first_release_date,game.franchise.name,game.franchises,game.genres.name,game.name,game.release_dates,game.status,game.storyline,game.summary,game.total_rating,game.total_rating_count,game.updated_at,game.url,game.version_parent,game.version_title.name"*/
    let GAME_FIELDS =  " age_ratings,checksum,collection.name,cover.url,created_at,first_release_date,franchise.name,franchises,genres.name,name,release_dates,status,storyline,summary,total_rating,total_rating_count,updated_at,url,version_parent,version_title,platforms.name"
    let FULL_GAME_FIELDS =  " age_ratings.category, age_ratings.rating, category, collection.name, cover.url, first_release_date, follows, game_modes.name, genres.name, hypes, involved_companies.developer, involved_companies.publisher, involved_companies.supporting, involved_companies.company.name, player_perspectives.name, name, themes.name, platforms.abbreviation, platforms.name, screenshots.url, slug, summary, storyline, status, total_rating, total_rating_count, url, similar_games.name, similar_games.cover.url"
    let PLATFORM_FIELDS = "platform.name"
    let RELEASE_FIELDS = "id,category,checksum,created_at,date,human,platform,updated_at"
    
    private init() {
        
    }
    
    func search(gameTitle: String) async throws -> GamesList {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.games.rawValue
        //let filter = "where first_release_date < \(nowTimestamp) & themes != (42)"
        //let requestBody = "fields \(GAME_FIELDS), \(RELEASE_FIELDS), \(PLATFORM_FIELDS); \(filter); \(sort); \(limit);"
        let limit = "limit 20"
        let requestBody = "search \"\(gameTitle)\"; fields \(GAME_FIELDS); \(limit);";
       
        let searchResult = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: GamesList.self)
        
        if searchResult != nil {
            for game in searchResult! {
                print("Result: \(game.name) on \(game.firstReleaseDate ?? 0)")
            }
        }
        
        return searchResult ?? []
    }
    
    func recentReleases() async throws -> GamesList {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.games.rawValue
        let nowTimestamp = Int(Date.now.timeIntervalSince1970)
        let filter = "where first_release_date < \(nowTimestamp) & themes != (42)"
        let sort = "sort first_release_date desc "
        let limit = "limit 10"
        //let requestBody = "fields \(GAME_FIELDS), \(RELEASE_FIELDS), \(PLATFORM_FIELDS); \(filter); \(sort); \(limit);"
        let requestBody = "fields \(GAME_FIELDS); \(filter); \(sort); \(limit);"
       
        let releases = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: GamesList.self)
        
        if releases != nil {
            for game in releases! {
                print("Relesase: \(game.name) on \(game.firstReleaseDate ?? 0)")
            }
        }
        
        return releases ?? []
        
        /*
         fields date, human, platform.name, game.name, game.cover.url; where date < 1683354842; sort date desc; limit 10;
         fields *, platform.*, game.*; where date < 1683354842; sort date desc; limit 10;
         */
        
       
        
    }
    
    func nextReleases() async throws -> GamesList {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.games.rawValue
        let nowTimestamp = Int(Date.now.timeIntervalSince1970)
        let filter = "where first_release_date > \(nowTimestamp) & themes != (42)"
        let sort = "sort first_release_date asc "
        let limit = "limit 10"
        //let requestBody = "fields \(GAME_FIELDS), \(RELEASE_FIELDS), \(PLATFORM_FIELDS); \(filter); \(sort); \(limit);"
        let requestBody = "fields \(GAME_FIELDS); \(filter); \(sort); \(limit);"
       
        let releases = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: GamesList.self)
        
        if releases != nil {
            for game in releases! {
                print("Relesase: \(game.name) on \(game.firstReleaseDate ?? 0)")
            }
        }
        
        return releases ?? []
    }
    
    func topRated() async throws -> GamesList {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.games.rawValue
        let filter = "where total_rating != null & total_rating_count > 100"
        let sort = "sort total_rating desc"
        let limit = "limit 10"
        let requestBody = "fields \(GAME_FIELDS); \(filter); \(sort); \(limit);"
               
        let topRatedGames = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: GamesList.self)
        
        if topRatedGames != nil {
            for topGame in topRatedGames! {
                print("Top Game: \(topGame.name) on \(topGame.firstReleaseDate ?? 0)")
            }
        }
        
        return topRatedGames ?? []
    }
    
    func singleGame(byId gameID: Int) async throws -> FullGame? {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.games.rawValue
        let filter = "where id = \(gameID)"
        let requestBody = "fields \(FULL_GAME_FIELDS); \(filter);"
       
        if let singleGame = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: FullGameList.self){
            
            if singleGame.count > 0{
                let game = singleGame[0]
                print("Game Fetched: \(game)")
                return game
            }
        }
        
        return nil
    }
    
    private func makeRequest<T: Decodable>(
        withRawBody requestBody:String,
        withUrlString urlString: String,
        classToDecode type: T.Type) async throws -> T? {
        
        let request = IGDBRequest()
        let responseData = try await request.performPostRequest(urlString: urlString, rawBody: requestBody)
        if let data = responseData {
            let responseString = String(data: data, encoding: .utf8)
           // print(responseString ?? "NO DATA")
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                //if let releases = releasesResult {
                return decodedData
                //}
            } catch {
                print("parse error: \(String(describing: error))")
            }
        }
         
        return nil
    }
}

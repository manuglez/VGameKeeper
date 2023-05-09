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
    
    private let GAME_FIELDS =  " game.age_ratings,game.checksum,game.collection.name,game.cover.url,game.created_at,game.first_release_date,game.franchise.name,game.franchises,game.genres.name,game.name,game.release_dates,game.status,game.storyline,game.summary,game.total_rating,game.total_rating_count,game.updated_at,game.url,game.version_parent,game.version_title"
    let PLATFORM_FIELDS = "platform.name"
    let RELEASE_FIELDS = "id,category,checksum,created_at,date,human,platform,updated_at"
    
    private init() {
        
    }
    private func makeRequest<T: Decodable>(
        withRawBody requestBody:String,
        withUrlString urlString: String,
        classToDecode type: T.Type) async throws -> T? {
        
        let request = IGDBRequest()
        let responseData = try await request.performPostRequest(urlString: urlString, rawBody: requestBody)
        if let data = responseData {
            let responseString = String(data: data, encoding: .utf8)
            print(responseString ?? "NO DATA")
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
    
    func recentReleases() async throws -> [Release] {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.releaseDates.rawValue
        let nowTimestamp = Int(Date.now.timeIntervalSince1970)
        let filter = "where date < \(nowTimestamp) & game.themes != (42)"
        let sort = "sort date desc "
        let limit = "limit 10"
        let requestBody = "fields \(GAME_FIELDS), \(RELEASE_FIELDS), \(PLATFORM_FIELDS); \(filter); \(sort); \(limit);"
       
        let releases = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: Releases.self)
        
        if releases != nil {
            for rel in releases! {
                print("Relesase: \(rel.game.name) on \(rel.human)")
            }
        }
        
        return releases ?? []
        
        /*
         fields date, human, platform.name, game.name, game.cover.url; where date < 1683354842; sort date desc; limit 10;
         fields *, platform.*, game.*; where date < 1683354842; sort date desc; limit 10;
         */
        
       
        
    }
    
    func nextReleases() async throws -> [Release] {
        let urlString = IGDBConstants.APIBaseUrl + Query_Endpoints.releaseDates.rawValue
        let nowTimestamp = Int(Date.now.timeIntervalSince1970)
        let filter = "where date > \(nowTimestamp) & game.themes != (42)"
        let sort = "sort date asc "
        let limit = "limit 10"
        let requestBody = "fields \(GAME_FIELDS), \(RELEASE_FIELDS), \(PLATFORM_FIELDS); \(filter); \(sort); \(limit);"
       
        let releases = try await makeRequest(withRawBody: requestBody, withUrlString: urlString, classToDecode: Releases.self)
        
        if releases != nil {
            for rel in releases! {
                print("Relesase: \(rel.game.name) on \(rel.human)")
            }
        }
        
        return releases ?? []
    }
    
}

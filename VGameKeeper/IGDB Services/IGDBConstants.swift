//
//  IGDBConstants.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 05/05/23.
//

import Foundation

class IGDBConstants {
    static let AuthBaseUrl = "https://id.twitch.tv/oauth2/token"
    static let APIBaseUrl = "https://api.igdb.com/v4/"
    
    static var CLIENT_ID: String {
        get {
            return readPlistFileValue(fileName: "IGDB-info", value: "client_id")
        }
    }
    
    static var CLIENT_SECRET: String {
        get {
            return readPlistFileValue(fileName: "IGDB-info", value: "client_secret")
        }
    }
    
    private static func readPlistFileValue(fileName: String, value: String) -> String{
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            return ""
        }
        if let igdb_info = NSDictionary(contentsOfFile: path) as? [String: String] {
            let client_id = igdb_info[value]
            return client_id ?? ""
        }
      
        return ""
    }
}

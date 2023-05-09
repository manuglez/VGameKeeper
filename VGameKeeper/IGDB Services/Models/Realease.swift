//
//  Realeases.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 06/05/23.
//

import Foundation
// MARK: - Release
struct Release: Codable {
    let id, category, createdAt, date: Int
    let game: Game
    let human: String
    let platform: IGDB_Item
    let updatedAt: Int
    let checksum: String

    enum CodingKeys: String, CodingKey {
        case id, category
        case createdAt = "created_at"
        case date, game, human, platform
        case updatedAt = "updated_at"
        case checksum
    }
}

typealias Releases = [Release]
/*
struct Release: Codable {
    let id, category, createdAt, date: Int
    let game: Int
    let human: String
    let platform, updatedAt: Int
    let checksum: String

    enum CodingKeys: String, CodingKey {
        case id, category
        case createdAt = "created_at"
        case date, game, human, platform
        case updatedAt = "updated_at"
        case checksum
    }
}

typealias Releases = [Release]
struct Release: Codable {
    let id, category, createdAt, date: Int
    let game: Game
    let human: String
    let m: Int
    let platform: Platform
    let region, updatedAt, y: Int
    let checksum: String

    enum CodingKeys: String, CodingKey {
        case id, category
        case createdAt = "created_at"
        case date, game, human, m, platform, region
        case updatedAt = "updated_at"
        case y, checksum
    }
}
*/

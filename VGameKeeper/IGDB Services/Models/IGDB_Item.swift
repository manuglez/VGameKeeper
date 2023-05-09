//
//  Platform.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 06/05/23.
//

import Foundation
// MARK: - Platform
struct IGDB_Item: Codable {
    let id: Int
    let name: String
}

/*
// MARK: - Platform
struct Platform: Codable {
    let id: Int
    let abbreviation, alternativeName: String
    let category, createdAt, generation: Int
    let name: String
    let platformLogo, platformFamily: Int
    let slug: String
    let updatedAt: Int
    let url: String
    let versions, websites: [Int]
    let checksum: String

    enum CodingKeys: String, CodingKey {
        case id, abbreviation
        case alternativeName = "alternative_name"
        case category
        case createdAt = "created_at"
        case generation, name
        case platformLogo = "platform_logo"
        case platformFamily = "platform_family"
        case slug
        case updatedAt = "updated_at"
        case url, versions, websites, checksum
    }
}
*/

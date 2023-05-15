//
//  FeaturedGame.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/05/23.
//

import Foundation

struct FeaturedGame: Identifiable{
    var id: UUID
    var dbIdentifier: Int
    var name: String
    //var platformName: String
    var imageUrl: String
    var imageData: Data?
    
    func thumbnailUrl() -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        if imageUrl.starts(with: "https:") {
            return imageUrl
        }
        return "https:\(imageUrl)"
       
    }
    
    func xsmallSizeUrl() -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_small")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
    
    func smallSizeUrl() -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_small_2x")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
    
    func mediumSizeUrl() -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_big")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
    
    func bigSizeUrl() -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_big_2x")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
}

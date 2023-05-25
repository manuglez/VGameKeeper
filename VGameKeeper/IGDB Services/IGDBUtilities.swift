//
//  IGDBUtilities.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import Foundation

enum Game_Category: Int {
    case main_game = 0
    case dlc_addon = 1
    case expansion = 2
    case bundle = 3
    case standalone_expansion = 4
    case mod = 5
    case episode = 6
    case season = 7
    case remake = 8
    case remaster = 9
    case expanded_game = 10
    case port = 11
    case fork = 12
    case pack = 13
    case update = 14
}
    
/*
main_game    0
dlc_addon    1
expansion    2
bundle    3
standalone_expansion    4
mod    5
episode    6
season    7
remake    8
remaster    9
expanded_game    10
port    11
fork    12
pack    13
update    14
 */
class IGDBUtilities {
    static func itemArrayToStringArray(originalArray: [IGDB_Item]) -> [String] {
        var stringArray: [String] = []
        for item in originalArray {
            stringArray.append(item.name)
        }
        return stringArray
    }
    
    static func thumbnailUrl(_ imageUrl: String) -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        if imageUrl.starts(with: "https:") {
            return imageUrl
        }
        return "https:\(imageUrl)"
       
    }
    
    static func xsmallSizeUrl(_ imageUrl: String) -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_small")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
    
    static func smallSizeUrl(_ imageUrl: String) -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_small_2x")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
    
    static func mediumSizeUrl(_ imageUrl: String) -> String {
        guard !imageUrl.isEmpty else {
            return ""
        }
        let stringUrl = imageUrl.replacingOccurrences(of: "t_thumb", with: "t_cover_big")
        if stringUrl.starts(with: "https:") {
            return stringUrl
        }
        return "https:\(stringUrl)"
    }
    
    static func bigSizeUrl(_ imageUrl: String) -> String {
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

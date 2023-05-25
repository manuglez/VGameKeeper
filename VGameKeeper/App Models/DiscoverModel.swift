//
//  DiscoverModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/05/23.
//

import Foundation

struct DiscoverModel {
    var sectionName: String
    var gamesList: [FeaturedGame]
    var reloadPending: Bool = false
}

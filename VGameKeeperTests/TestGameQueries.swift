//
//  TestGameQueries.swift
//  VGameKeeperTests
//
//  Created by Manuel Gonzalez on 26/07/23.
//

import Foundation
class TestGameQueries: GameQueries{
    func recentReleases() async throws -> GamesList {
        return GamesList()
    }
    
    func topRated() async throws -> GamesList {
        return GamesList()
    }
    
    func nextReleases() async throws -> GamesList {
        return GamesList()
    }
}

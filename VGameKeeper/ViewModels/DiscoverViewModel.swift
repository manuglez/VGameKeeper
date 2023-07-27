//
//  DiscoverViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/05/23.
//

import Foundation

protocol GameQueries {
    func recentReleases() async throws -> GamesList
    func nextReleases() async throws -> GamesList
    func topRated() async throws -> GamesList
}

class DiscoverViewModel: ViewModel {
    var discoveries: [DiscoverModel] = []
    var gameQueries: GameQueries
    
    init(gameQueries: GameQueries) {
        self.gameQueries = gameQueries
    }
    
    func fetchDiscoveries(completion : @escaping () -> ()) {
        Task {
            do {
                discoveries = []
                
                let newReleases = try await gameQueries.recentReleases()//IGDBGameQuery.shared.recentReleases()
                discoveries.append(parseModelsGames(apiResult: newReleases, collectonName: "Nuevos Lanzamientos"))
                
                let resultNextReleases = try await gameQueries.nextReleases()//IGDBGameQuery.shared.nextReleases()
                discoveries.append(parseModelsGames(apiResult: resultNextReleases, collectonName: "Próximos Lanzamientos"))
                
                let topRatedGames = try await gameQueries.topRated()//IGDBGameQuery.shared.topRated()
                discoveries.append(parseModelsGames(apiResult: topRatedGames, collectonName: "Mejor Puntuados"))
                
            } catch {
                print("🚨 IGDBGameQuery Error: \(error.localizedDescription)")
            }
            completion()
        }
    }
}

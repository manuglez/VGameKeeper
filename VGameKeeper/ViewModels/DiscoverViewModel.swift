//
//  DiscoverViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/05/23.
//

import Foundation

class DiscoverViewModel: ViewModel {
    var discoveries: [DiscoverModel] = []
    
    func fetchDiscoveries(completion : @escaping () -> ()) {
        Task {
            do {
                discoveries = []
                
                let newReleases = try await IGDBGameQuery.shared.recentReleases()
                discoveries.append(parseModelsGames(apiResult: newReleases, collectonName: "Nuevos Lanzamientos"))
                
                let resultNextReleases = try await IGDBGameQuery.shared.nextReleases()
                discoveries.append(parseModelsGames(apiResult: resultNextReleases, collectonName: "Próximos Lanzamientos"))
                
                let topRatedGames = try await IGDBGameQuery.shared.topRated()
                discoveries.append(parseModelsGames(apiResult: topRatedGames, collectonName: "Mejor Puntuados"))
                
            } catch {
                print("🚨 IGDBGameQuery Error: \(error.localizedDescription)")
            }
            completion()
        }
    }
}

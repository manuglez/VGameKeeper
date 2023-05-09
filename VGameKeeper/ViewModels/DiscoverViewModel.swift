//
//  DiscoverViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 08/05/23.
//

import Foundation

class DiscoverViewModel {
    var discoveries: [DiscoverModel] = []
    
    func fetchDiscoveries(completion : @escaping () -> ()) {
        Task {
            do {
                discoveries = []
                
                let newReleases = try await IGDBGameQuery.shared.recentReleases()
                discoveries.append(parseModels(apiResult: newReleases, collectonName: "Nuevos Lanzamientos"))
                
                let resultNextReleases = try await IGDBGameQuery.shared.nextReleases()
                discoveries.append(parseModels(apiResult: resultNextReleases, collectonName: "Próximos Lanzamientos"))
                
            } catch {
                print("🚨 IGDBGameQuery Error: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    private func parseModels(apiResult: [Release], collectonName: String) -> DiscoverModel{
        var viewModelItem = [FeaturedGame]()
        for releaseItem in apiResult {
            viewModelItem.append(modelToViewModel(model: releaseItem))
        }
        return DiscoverModel(sectionName: collectonName, gamesList: viewModelItem)
    }
    
    private func modelToViewModel(model: Release) -> FeaturedGame {
        let featured = FeaturedGame(
                id: UUID(),
                dbIdentifier: model.id,
                name: model.game.name,
                platformName: model.platform.name,
                imageUrl: model.game.cover.url)
        return featured
    }
}

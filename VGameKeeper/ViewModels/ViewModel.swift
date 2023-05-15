//
//  ViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 12/05/23.
//

import Foundation

class ViewModel {
    
}

extension ViewModel {
    internal func parseModelsGames(apiResult: GamesList, collectonName: String) -> DiscoverModel{
        var viewModelItem = [FeaturedGame]()
        for releaseItem in apiResult {
            viewModelItem.append(modelToViewModelGames(model: releaseItem))
        }
        return DiscoverModel(sectionName: collectonName, gamesList: viewModelItem)
    }
    
    internal func modelToViewModelGames(model: Game) -> FeaturedGame {
        let featured = FeaturedGame(
                id: UUID(),
                dbIdentifier: model.id,
                name: model.name,
                //platformName: model.platforms?.name ?? "NO PLATFORM",
                imageUrl: model.cover?.url ?? "")
        return featured
    }
    
    internal func parseModels(apiResult: [Release], collectonName: String) -> DiscoverModel{
        var viewModelItem = [FeaturedGame]()
        for releaseItem in apiResult {
            viewModelItem.append(modelToViewModel(model: releaseItem))
        }
        return DiscoverModel(sectionName: collectonName, gamesList: viewModelItem)
    }
    
    internal func modelToViewModel(model: Release) -> FeaturedGame {
        let featured = FeaturedGame(
                id: UUID(),
                dbIdentifier: model.id,
                name: model.game.name,
                //platformName: model.platform.name,
                imageUrl: model.game.cover?.url ?? "")
        return featured
    }
}

//
//  GameSearchViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 12/05/23.
//

import Foundation

class GameSearchViewModel: ViewModel {
    private let searchQueue = DispatchQueue(label: "gameSearchQueue")
    private var safeGamesList: [FeaturedGame] = []
    
    var gamesList: [FeaturedGame] {
        get {
            var tempList: [FeaturedGame]!
            self.searchQueue.sync {
                tempList = self.safeGamesList
            }
            return tempList
        }
    }
    
    
    
    func fetchSearch(query: String, completion : @escaping () -> ()) {
        Task {
            
            let searchResult = try await IGDBGameQuery.shared.search(gameTitle: query)
            
            searchQueue.async (flags: .barrier){
                self.safeGamesList.removeAll()
                for modelGame in searchResult {
                    let gameItem = self.modelToViewModelGames(model: modelGame)
                    self.safeGamesList.append(gameItem)
                }
                    
            }
                        
            completion()
        }
    }
}

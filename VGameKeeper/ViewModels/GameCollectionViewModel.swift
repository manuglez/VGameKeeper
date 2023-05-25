//
//  GameCollectionViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 18/05/23.
//

import Foundation

class GameCollectionViewModel {
    var gameLists = [GameCollectionItem]()
    private static let defaultSections = ["Jugando", "Pendiente", "Lista de deseos", "En Pausa", "Terminados"]
    init() {
        for itemTitle in GameCollectionViewModel.defaultSections {
            gameLists.append(GameCollectionItem(name: itemTitle))
        }
        
    }
    
    static var getDefaultCollection: [String] {
        get {
            return GameCollectionViewModel.defaultSections
        }
    }
}

enum CollectionCategory: Int {
    case jugando = 1
    case pendiente = 2
    case enLaMira = 3
    case enPausa = 4
    case terminado = 5
}

struct GameCollectionItem {
    var name: String
    var isOpen: Bool = true
    var gameList: [FeaturedGame] = []
}

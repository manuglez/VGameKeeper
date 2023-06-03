//
//  GameCollectionViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 18/05/23.
//

import Foundation

enum CollectionCategoryIndex: Int {
    case jugando = 0
    case pendiente = 1
    case enLaMira = 2
    case enPausa = 3
    case terminado = 4
}

enum CollectionCategoryName: String {
    case jugando = "Jugando"
    case pendiente = "Pendiente"
    case enLaMira = "Lista de deseos"
    case enPausa = "En pausa"
    case terminado = "Terminado"
}

struct GameCollectionItem {
    var name: CollectionCategoryName
    var category: CollectionCategoryIndex
    var isOpen: Bool = true
    var gameCollection: [FeaturedGame] = []
}

class GameCollectionViewModel: ViewModel {
    var gameLists = [GameCollectionItem]()
    private static let defaultSections: [(CollectionCategoryIndex, CollectionCategoryName)] = [
        (CollectionCategoryIndex.jugando, CollectionCategoryName.jugando),
        (CollectionCategoryIndex.pendiente, CollectionCategoryName.pendiente),
        (CollectionCategoryIndex.enLaMira, CollectionCategoryName.enLaMira),
        (CollectionCategoryIndex.enPausa, CollectionCategoryName.enPausa),
        (CollectionCategoryIndex.terminado, CollectionCategoryName.terminado)
    ]
    
    override init() {
        super.init()
        var index = 0
        for sectionItem in GameCollectionViewModel.defaultSections {
            let gameCollectionItem = GameCollectionItem(
                name: sectionItem.1 ,
                category: sectionItem.0
            )
            gameLists.append(gameCollectionItem)
            index += 1
        }
        
    }
    
    static var getDefaultCollection: [String] {
        get {
            return GameCollectionViewModel.defaultSections.map { $0.1.rawValue }
        }
    }
    
    func fetchCollections(completion : @escaping () -> ()) {
        Task {
            clearCollections()
            let firestore = FirestoreService()
            let data = try await firestore.queryUserCollections()
            for collectionItem in data {
                let gameCategory = collectionItem["categoria"] as? Int ?? -1
                if gameCategory != -1 {
                    let categoryIndex = gameLists.firstIndex(where: { $0.category.rawValue == gameCategory })
                    if let catIndex = categoryIndex {
                        var categoryModel = gameLists[catIndex]
                        let gameData: [String: Any] = collectionItem["juego"] as! [String : Any]
                        let featuredGame = FeaturedGame(
                            id: UUID(),
                            dbIdentifier: gameData["externalID"] as? Int ?? 0,
                            name: gameData["nombre"] as? String ?? "",
                            imageUrl: gameData["cover-url"] as? String ?? "")
                        
                        categoryModel.gameCollection.append(featuredGame)
                        gameLists[catIndex] = categoryModel
                        
                    } /*else {
                        categoryModel = GameCollectionItem(
                            name: CollectionCategoryName(rawValue: categoryName)!,
                            category: CollectionCategoryIndex(rawValue: gameCategory)!
                        )
                    }*/
                    
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func clearCollections() {
        for i in 0..<gameLists.count {
            gameLists[i].gameCollection.removeAll()
        }
    }
}

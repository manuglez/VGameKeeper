//
//  GameCollectionViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 18/05/23.
//

import Foundation
import UIKit

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
    
    private let cd_context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    func fetchFromCoredata() -> Bool {//[FeaturedGame]{
        print("******** Fetch form Core Data")
        do {
            
            let cd_gamesList = try cd_context.fetch(CD_Game.fetchRequest())
            
            buildViewModel(gameDataList: cd_gamesList)
            
            return cd_gamesList.count > 0
        } catch {
            
        }
        
        return false
    }
    
    func fetchFromFirestore() async{
        
        print("******** Fetch form Firestore")
        let firestore = FirestoreService()
        guard firestore.hasUserData() else {
            print("******** No User Data")
            return
        }
        do {
            let firestoreData = try await firestore.queryUserCollections()
            let coredata = CoreDataService.shared
            var cd_gamesList: [CD_Game] = []
            for collectionItem in firestoreData {
                let gameCategory = collectionItem["categoria"] as? Int ?? -1
                if gameCategory != -1 {
                        
                    let gameData: [String: Any] = collectionItem["juego"] as! [String : Any]
                    //let gameID = UUID()
                    let gameName = gameData["nombre"] as? String ?? ""
                    let gameExternalID = gameData["externalID"] as? Int ?? 0
                    let gameImageUrl = gameData["cover-url"] as? String ?? ""
                    let document_id = gameData["docid"] as? String ?? ""
                    
                    let cd_item = coredata.createGame(
                        documentID: document_id,
                        name: gameName,
                        imageUrl: gameImageUrl,
                        externalID: gameExternalID,
                        collectionCategory: gameCategory
                    )
                    if cd_item != nil {
                        cd_gamesList.append(cd_item!)
                    }
                    
                }
            }
            
            buildViewModel(gameDataList: cd_gamesList)
            
        }catch (let err){
            print("Error fetching Firestore Collections \(err.localizedDescription)")
        }
    }
    
    func fetchCollections(completion : @escaping () -> ()) {
        Task {
            clearViewModelCollections()
            if AppDefaultsWrapper.shared.firstRunLoad {
                CoreDataService.shared.clearGamesData()
               await fetchFromFirestore()
               AppDefaultsWrapper.shared.firstRunLoad = false
            }else {
                let _ = fetchFromCoredata()
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func buildViewModel(gameDataList: [CD_Game]){
        for gameData in gameDataList {
            let gameCategory = Int(gameData.collectionCategory)
            let categoryIndex = gameLists.firstIndex(where: { $0.category.rawValue == gameCategory })
            if let catIndex = categoryIndex {
                
                var categoryModel = gameLists[catIndex]
                
                let featuredGame = FeaturedGame(
                    id: UUID(),
                    dbIdentifier: Int(gameData.externalID),
                    name: gameData.name ?? "NONAME",
                    imageUrl: gameData.coverUrl ?? "")
                print("featured: \(featuredGame.name) (\(gameCategory)")
                categoryModel.gameCollection.append(featuredGame)
                gameLists[catIndex] = categoryModel
            }
        }
    }
    
    func clearViewModelCollections() {
        for i in 0..<gameLists.count {
            gameLists[i].gameCollection.removeAll()
        }
    }
}

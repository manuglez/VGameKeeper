//
//  GameDetailViewModel.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 09/05/23.
//

import Foundation
import FirebaseFirestore.FIRDocumentReference

enum DetailItemType{
    case header
    case textField
    case textValue
    case horizontalGrid
    case multipleText
}
struct DetailModel {
    static let DATA_HEADER_COLLECTION_KEY = "collection"
    var itemType: DetailItemType
    var mainText: (String, String)? // Label, Value
    var secondaryText: (String, String)? // Label, Value
    var textSet: Set<String>?
    var dataDictionary: [String: Any]?
}

struct GameCollectionModel {
    var index: Int
    var name: String
}

class GameDetailViewModel: ViewModel {
    var gameInfo: GamePage?
    var items: [DetailModel] = []
    
    // MARK: Public Functions
    
    func fetchGameFullInfo(gameID: Int, completion : @escaping () -> ()){
        Task {
            if let gameResponse = try await IGDBGameQuery.shared.singleGame(byId: gameID) {
                gameInfo = seviceGameToAppGameInfo(serviceGameInfo: gameResponse)
                buildModels()
            }
            
            try await searchFirestoreCollections(gameID: gameID)
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func addGameToCollection(game: FeaturedGame, gameCollection: GameCollectionModel, completion : @escaping () -> ()) {
        Task {
            //le db = Firestore.firestore()
            //let ref = await db.collection("juegos").whereField("igdbID", isEqualTo: game.dbIdentifier).get
            let fr = FirestoreService()
            print("Searching for game \(game.name) (\(game.dbIdentifier))")
            var gref = await fr.findGame(byExternalId: game.dbIdentifier)
                
            if gref == nil {
                print("Creating new game Instance...")
                gref = await fr.createGame(game: game)
            } else {
                print("Game Founded...")
            }
            
            guard let gameRef = gref else{
                print("Error creating game...")
                completion()
                return
            }
            
            print("Saving to collection: \(gameCollection.name) (\(gameCollection.index))")
            let collectionReference = await fr.addGameToCollection(gameReference: gameRef, gameCollection: gameCollection)
            
            if collectionReference != nil {
                try await buildCollectionModel(gameRef: gameRef)
                print("Succes collection saving")
            } else {
                print("Error sacing collection")
            }
            DispatchQueue.main.async {
                completion()
            }
            
        }
    }
    
    func removeGameFromCollection(game: FeaturedGame, completion : @escaping () -> ()) {
        Task {
            let db = FirestoreService()
            try await db.removeGameFromCollection(gameID: game.dbIdentifier)
            removeCollectionFromViewModel()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: Private Functions
    
    private func buildModels() {
        items.removeAll()
        
        let headerItem = DetailModel(
            itemType: .header,
            mainText: ("Title", gameInfo?.name ?? "NO TILE"),
            secondaryText: ("Cover Url", IGDBUtilities.bigSizeUrl(gameInfo?.coverUrl ?? "")),
            dataDictionary: ["cover_url" : gameInfo?.coverUrl ?? ""]
        )
        items.append(headerItem)
        
        if let release = gameInfo?.firstRelease {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            let dateText = formatter.string(from: release)
            let seriesItem = DetailModel(
                itemType: .textValue,
                mainText: ("Lanzamiento inicial", dateText)
            )
            items.append(seriesItem)
        }
        
        if let gameSeries = gameInfo?.collection,
        gameSeries != ""{
            let seriesItem = DetailModel(
                itemType: .textValue,
                mainText: ("Series", gameSeries) )
            items.append(seriesItem)
        }
        
        if let gameSummary = gameInfo?.summary,
        gameSummary != ""{
            let summaryItem = DetailModel(
                itemType: .textField,
                mainText: ("Resumen", gameSummary)
            )
            items.append(summaryItem)
        }
        
        if let gameStoryline = gameInfo?.storyline,
        gameStoryline != ""{
            let storylineItem = DetailModel(
                itemType: .textField,
                mainText: ("Línea argumental", gameStoryline) )
            items.append(storylineItem)
        }
    }
    
    private func searchFirestoreCollections(gameID: Int) async throws {
        let fr = FirestoreService()
        if let gameRef = await fr.findGame(byExternalId: gameID) {
            try await buildCollectionModel(gameRef: gameRef)
        }
    }
    
    private func removeCollectionFromViewModel(){
        let headerItem = items.first { $0.itemType == .header }
        let headerIndex = items.firstIndex { $0.itemType == .header }
        
        guard var dataInfo = headerItem?.dataDictionary else {
            return
        }
        
        dataInfo[DetailModel.DATA_HEADER_COLLECTION_KEY] = nil
        items[headerIndex!].dataDictionary = dataInfo
    }
    
    private func buildCollectionModel(gameRef: DocumentReference) async throws  {
        let fr = FirestoreService()
        if let collectionInfo = try await fr.queryCollectionInfo(gameReference: gameRef){
            print("Game In a Collection")
            let collectionModel: GameCollectionModel = GameCollectionModel(
                index: collectionInfo["category"] as! Int  , name: collectionInfo["name"] as! String)
            let headerItem = items.first { $0.itemType == .header }
            let headerIndex = items.firstIndex { $0.itemType == .header }
            var dataInfo = headerItem?.dataDictionary
            if dataInfo == nil {
                dataInfo = [:]
            }
            dataInfo?[DetailModel.DATA_HEADER_COLLECTION_KEY] = collectionModel
            items[headerIndex!].dataDictionary = dataInfo
        }
    }
    
    private func seviceGameToAppGameInfo(serviceGameInfo: FullGame) -> GamePage {
        var game = GamePage()
        game.ageRatings = serviceGameInfo.ageRatings?.map{
            AgeRate_Game(rating: $0.rating, category: $0.category)
        }
        game.category = Game_Category(rawValue: serviceGameInfo.category ?? 0)
        if let serviceCollection = serviceGameInfo.collection {
            game.collection = serviceCollection.name
        }
        
        if let serviceCover = serviceGameInfo.cover {
            game.coverUrl = serviceCover.url
        }
        game.externalPageUrl = serviceGameInfo.url
        
        game.gameModes = serviceGameInfo.gameModes?.map { $0.name }
        
        game.genres = serviceGameInfo.genres?.map { $0.name }
        
        if let serviceDate = serviceGameInfo.firstReleaseDate {
            game.firstRelease = Date(timeIntervalSince1970: TimeInterval(serviceDate))
        }
        
        game.follows = serviceGameInfo.follows ?? 0
        game.hypes = serviceGameInfo.hypes ?? 0
        game.name = serviceGameInfo.name
        
        game.platforms = serviceGameInfo.platforms?.map { $0.name }
        
        game.playerPerspectives = serviceGameInfo.playerPerspectives?.map { $0.name }
        
        game.similarGames = serviceGameInfo.similarGames?.map {
            FeaturedGame(id: UUID(), dbIdentifier: $0.id, name: $0.name, imageUrl: $0.cover?.url ?? "" )
        }
        
        game.screenshots = serviceGameInfo.screenshots?.map { $0.url }
        
        game.slug = serviceGameInfo.slug ?? ""
        
        game.storyline = serviceGameInfo.storyline ?? ""
        
        game.summary = serviceGameInfo.summary ?? ""
        
        game.themes = serviceGameInfo.themes?.map { $0.name }
        
        game.totalRating = serviceGameInfo.totalRating ?? 0
        
        game.totalRatingCount = serviceGameInfo.totalRatingCount ?? 0
        
        return game
    }
    
    
}

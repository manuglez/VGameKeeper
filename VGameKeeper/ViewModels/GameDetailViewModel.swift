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
    case screenshots
    case horizontalGrid
    case multipleText
    case section
}
struct DetailModel {
    static let DATA_HEADER_COLLECTION_KEY = "collection"
    static let DATA_HEADER_BACKGROUND_KEY = "background"
    static let DATA_HGRID_SIMILARGAMES_KEY = "featuredList"
    
    var itemType: DetailItemType
    var mainText: (String, String)? // Label, Value
    var secondaryText: (String, String)? // Label, Value
    var textSet: Set<String>?
    var dataDictionary: [String: Any]?
    var textArray: [String]?
    var highlight: Bool = false
}

struct GameCollectionModel {
    var index: Int
    var name: String
}

class GameDetailViewModel: ViewModel {
    var gameInfo: GamePage?
    var viewItems: [DetailModel] = []
    
    let cd_context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
            let coredata = CoreDataService.shared
            let fr = FirestoreService()
            
            // Search game ID in core Data
            if let savedGame = coredata.game(withExternalID: game.dbIdentifier){
                // Update collection info in Core data
                coredata.updateGame(game: savedGame, collectionCategory: gameCollection.index)
                // Save Info to Firestore
               let _ = await fr.addGameToCollection(documentID: savedGame.firestoreDocumentID!, gameCollection: gameCollection)
            } else {
                // Search game ID in Firestore
                var gref = await fr.findGame(byExternalId: game.dbIdentifier)
                    
                if gref == nil {
                    gref = await fr.createGame(game: game)
                }
                
                guard let gameRef = gref else{
                    print("Error creating game...")
                    completion()
                    return
                }
                
                // Save Collection in Core Data
                let docID = gref?.documentID ?? ""
                let _ = coredata.createGame(documentID: docID, name: game.name, imageUrl: game.imageUrl, externalID: game.dbIdentifier, collectionCategory: gameCollection.index)
                
                // Add Game to Collection to Firestore
                let _ = await fr.addGameToCollection(gameReference: gameRef, gameCollection: gameCollection)
                
                
            }
            
            try await updateViewModelHeader(collectionModel: gameCollection)
            //le db = Firestore.firestore()
            //let ref = await db.collection("juegos").whereField("igdbID", isEqualTo: game.dbIdentifier).get
            
            
            DispatchQueue.main.async {
                completion()
            }
            
        }
    }
    
    /*func saveCollectionToFirestore(collectionReference: DocumentReference?) async{
        if collectionReference != nil {
            try await buildCollectionModel(gameRef: gameRef)
        } else {
            print("Error saving collection")
        }
    }*/
    
    func removeGameFromCollection(game: FeaturedGame, completion : @escaping () -> ()) {
        Task {
            let db = FirestoreService()
            try await db.removeGameFromCollection(gameID: game.dbIdentifier)
            let coredata = CoreDataService.shared
            let deleted = coredata.deletegGame(withExternalID: game.dbIdentifier)
            print("game Deleted: \(game.name) -> (\(deleted))")
            removeCollectionFromViewModel()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getCollectionIndex() -> Int {
        let headerItem = viewItems.first { $0.itemType == .header }
        if let dataInfo = headerItem?.dataDictionary,
           let gameCollection = dataInfo[DetailModel.DATA_HEADER_COLLECTION_KEY] as? GameCollectionModel{
            return gameCollection.index
        }
        
        return -1
    }
    
    // MARK: Private Functions
    
    private func buildModels() {
        viewItems.removeAll()
        
        let headerItem = DetailModel(
            itemType: .header,
            mainText: ("Title", gameInfo?.name ?? "NO TILE"),
            secondaryText: ("Cover Url", IGDBUtilities.bigCoverSizeUrl(gameInfo?.coverUrl ?? "")),
            dataDictionary: [
                "cover_url" : gameInfo?.coverUrl ?? "",
                DetailModel.DATA_HEADER_BACKGROUND_KEY : gameInfo?.screenshots?[0] ?? ""
            ]
        )
        viewItems.append(headerItem)
        
        if let release = gameInfo?.firstRelease {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            let dateText = formatter.string(from: release)
            let seriesItem = DetailModel(
                itemType: .textValue,
                mainText: ("Lanzamiento inicial", dateText)
            )
            viewItems.append(seriesItem)
        }
        
        if let gameSeries = gameInfo?.collection,
        gameSeries != ""{
            let seriesItem = DetailModel(
                itemType: .textValue,
                mainText: ("Series", gameSeries) )
            viewItems.append(seriesItem)
        }
        
        if let platforms = gameInfo?.platforms {
            let platformsItem = DetailModel(
                itemType: .multipleText,
                mainText: ("Plataformas", "Plataformas"),
                textSet: Set(platforms)
            )
            viewItems.append(platformsItem)
        }
        
        if let genres = gameInfo?.genres {
            let genreItem = DetailModel(
                itemType: .multipleText,
                mainText: ("Géneros", "Géneros"),
                textSet: Set(genres)
            )
            viewItems.append(genreItem)
        }
        
        if let companies = gameInfo?.companies {
            let sectionItem = DetailModel(
                itemType: .section,
                mainText: ("Compañías", "Compañías")
            )
            viewItems.append(sectionItem)
            
            if let developers = companies[GamePage.COMPANY_DEVLOPERS_KEY]{
                let devsString = developers.joined(separator: "\n")
                let devItem = DetailModel(
                    itemType: .textValue,
                    mainText: ("Desarrollador", devsString)
                )
                viewItems.append(devItem)
            }
            
            if let publishers = companies[GamePage.COMPANY_PUBLISHER_KEY]{
                let pubsString = publishers.joined(separator: "\n")
                let pubItem = DetailModel(
                    itemType: .textValue,
                    mainText: ("Distribuidor", pubsString)
                )
                viewItems.append(pubItem)
            }
            
            if let supporters = companies[GamePage.COMPANY_SUPPORTING_KEY]{
                let supString = supporters.joined(separator: "\n")
                let supItem = DetailModel(
                    itemType: .textValue,
                    mainText: ("Desarrollador de apoyo", supString)
                )
                viewItems.append(supItem)
            }
        }
        
        if let themes = gameInfo?.themes {
            let themesItem = DetailModel(
                itemType: .multipleText,
                mainText: ("Temáticas", "Temáticas"),
                textSet: Set(themes)
            )
            viewItems.append(themesItem)
        }
        
        if let gameSummary = gameInfo?.summary,
        gameSummary != ""{
            let summaryItem = DetailModel(
                itemType: .textField,
                mainText: ("Resumen", gameSummary)
            )
            viewItems.append(summaryItem)
        }
        
        if let gameStoryline = gameInfo?.storyline,
        gameStoryline != ""{
            let storylineItem = DetailModel(
                itemType: .textField,
                mainText: ("Línea argumental", gameStoryline) )
            viewItems.append(storylineItem)
        }
        
        if let screenshotsList = gameInfo?.screenshots{
            let screenshotsItem = DetailModel(
                itemType: .screenshots,
                mainText: ("Screenshots", "Screenshots"),
                textArray: screenshotsList,
                highlight: true
            )
            viewItems.append(screenshotsItem)
        }
        
        if let similarGames = gameInfo?.similarGames {
            let sectionItem = DetailModel(
                itemType: .section,
                mainText: ("Juegos Similares", "Juegos Similares")
            )
            viewItems.append(sectionItem)
            
            let similarGamesItem = DetailModel(
                itemType: .horizontalGrid,
                mainText: ("Juegos Similares", "Juegos Similares"),
                dataDictionary: [DetailModel.DATA_HGRID_SIMILARGAMES_KEY: similarGames]
            )
            viewItems.append(similarGamesItem)
        }
    }
    
   private func searchFirestoreCollections(gameID: Int) async throws {
        let fr = FirestoreService()
       guard fr.hasUserData() else {
           return
       }
        if let gameRef = await fr.findGame(byExternalId: gameID) {
            try await buildCollectionModel(gameRef: gameRef)
        }
    }
    
    private func removeCollectionFromViewModel(){
        let headerItem = viewItems.first { $0.itemType == .header }
        let headerIndex = viewItems.firstIndex { $0.itemType == .header }
        
        guard var dataInfo = headerItem?.dataDictionary else {
            return
        }
        
        dataInfo[DetailModel.DATA_HEADER_COLLECTION_KEY] = nil
        viewItems[headerIndex!].dataDictionary = dataInfo
    }
    
    
    private func buildCollectionModel(gameRef: DocumentReference) async throws {
        let fr = FirestoreService()
        if let collectionInfo = try await fr.queryCollectionInfo(gameReference: gameRef){
            let collectionModel: GameCollectionModel = GameCollectionModel(
                index: collectionInfo["category"] as! Int  , name: collectionInfo["name"] as! String)
            try await updateViewModelHeader(collectionModel: collectionModel)
        }
    }
    
    private func updateViewModelHeader(collectionModel: GameCollectionModel) async throws  {
        /*let fr = FirestoreService()
        if let collectionInfo = try await fr.queryCollectionInfo(gameReference: gameRef){
            let collectionModel: GameCollectionModel = GameCollectionModel(
                index: collectionInfo["category"] as! Int  , name: collectionInfo["name"] as! String)*/
            let resultIndex = viewItems.firstIndex { $0.itemType == .header }
            guard let headerIndex = resultIndex else {
                return
            }
            let headerItem = viewItems[headerIndex]
           
            var dataInfo = headerItem.dataDictionary
            if dataInfo == nil {
                dataInfo = [:]
            }
            dataInfo?[DetailModel.DATA_HEADER_COLLECTION_KEY] = collectionModel
            viewItems[headerIndex].dataDictionary = dataInfo
       // }
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
        
        game.platforms = serviceGameInfo.platforms?.map { $0.abbreviation ?? $0.name }
        
        if let companies = serviceGameInfo.involvedCompanies {
            game.companies = [:]
            var developers: [String] = []
            var publisers: [String] = []
            var supporting: [String] = []
            
            for comp in companies {
                if comp.developer {
                    developers.append(comp.company.name)
                }
                
                if comp.publisher {
                    publisers.append(comp.company.name)
                }
                
                if comp.supporting {
                    supporting.append(comp.company.name)
                }
            }
            
            if developers.count > 0 {
                game.companies?[GamePage.COMPANY_DEVLOPERS_KEY] = developers
            }
            if publisers.count > 0 {
                game.companies?[GamePage.COMPANY_PUBLISHER_KEY] = publisers
            }
            if supporting.count > 0 {
                game.companies?[GamePage.COMPANY_SUPPORTING_KEY] = supporting
            }
        }
        
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

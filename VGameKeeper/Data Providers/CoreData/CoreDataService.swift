//
//  CoreDataService.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 03/06/23.
//

import Foundation
import UIKit.UIApplication
import CoreData

class CoreDataService {
    
    static let shared: CoreDataService = CoreDataService()
    private var moContext: NSManagedObjectContext!
           
    private init() {
        DispatchQueue.main.sync {
            self.moContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    func createFrom(featuredGame: FeaturedGame, documentID: String, collectionCategory: Int = -1) -> CD_Game?{
        return createGame(documentID: documentID, name: featuredGame.name, imageUrl: featuredGame.imageUrl, externalID: featuredGame.dbIdentifier)
    }
    
    func createGame(documentID: String, name: String, imageUrl: String, externalID: Int, collectionCategory: Int = -1) -> CD_Game?{
        
        let newGame = CD_Game(context: moContext)
        newGame.firestoreDocumentID = documentID
        newGame.name = name
        newGame.coverUrl = imageUrl
        newGame.externalID = Int64(externalID)
        newGame.collectionCategory = Int64(collectionCategory)
        newGame.id = UUID()
        
        do {
            try moContext.save()
            return newGame
        } catch (let err){
            print ("Core Data Create Error")
            print(err.localizedDescription)
        }
        
        return nil
    }
    
    func updateGame(withDocumentID: String, collectionCategory: Int? = nil, name: String? = nil, imageUrl: String? = nil, externalID: Int? = nil){
        if let game = game(withDocumentID: withDocumentID){
            updateGame(game: game, collectionCategory: collectionCategory, name: name, imageUrl: imageUrl, externalID: externalID)
        }
    }
        
    func updateGame(game: CD_Game, collectionCategory: Int? = nil, name: String? = nil, imageUrl: String? = nil, externalID: Int? = nil){
            
        if let category = collectionCategory {
            game.collectionCategory = Int64(category)
        }
        
        if let n = name {
            game.name = n
        }
        
        if let url = imageUrl {
            game.coverUrl = url
        }
        
        if let extid = externalID {
            game.externalID = Int64(extid)
        }
        
        do {
            try moContext.save()
        } catch (let err){
            print ("Core Data Update Error")
            print(err.localizedDescription)
        }
    }
    
    func game(withExternalID externalID: Int) -> CD_Game? {
        let predicate = NSPredicate(format: "externalID == %@", NSNumber(integerLiteral: externalID))
        return game(withPredicate: predicate)
    }
        
    func game(withDocumentID documentID: String) -> CD_Game? {
        let predicate = NSPredicate(format: "firestoreDocumentID == %@", documentID)
        return game(withPredicate: predicate)
    }
    
    private func game(withPredicate predicate: NSPredicate) -> CD_Game? {
        do {
            let request = CD_Game.fetchRequest() as NSFetchRequest<CD_Game>
            request.predicate = predicate
            let games = try moContext.fetch(request)
            return games.first
        } catch (let err){
            print ("Core Data Get Error")
            print(err.localizedDescription)
        }
        
        return nil
    }
    
    func fetchGames() -> [CD_Game]?{
        do {
            let games = try moContext.fetch(CD_Game.fetchRequest())
            return games
        } catch (let err){
            print ("Core Data Fetch Error")
            print(err.localizedDescription)
        }
        
        return nil
    }
    
    func deletegGame(withExternalID externalID: Int) -> Bool {
        let predicate = NSPredicate(format: "externalID == %@", NSNumber(integerLiteral: externalID))
        if let game = game(withPredicate: predicate) {
            moContext.delete(game)
            return true
        }
        
        return false
    }
    
    
    func clearGamesData(){
        do {
            if let games = fetchGames(){
                for g in games {
                    moContext.delete(g)
                }
                try moContext.save()
            }
        } catch (let err){
            print ("Core Data Fetch Error")
            print(err.localizedDescription)
        }
    }
    
}

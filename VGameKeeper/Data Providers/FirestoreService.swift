//
//  FirestoreService.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 23/05/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum Firestore_Colecctions: String {
    case juegos = "juegos"
    case coleccion = "coleccion"
    case usuarios = "usuarios"
}

class FirestoreService {
    let db = Firestore.firestore()

    lazy var userReference: DocumentReference = {
        let user_uid = Auth.auth().currentUser!.uid
        return self.db.collection(Firestore_Colecctions.usuarios.rawValue).document(user_uid)
    }()
    
    func hasUserData() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func query(collectionName: Firestore_Colecctions, fieldName: String, value: Any) async throws ->  QuerySnapshot {
        
        let snapshot = try await db.collection(collectionName.rawValue).whereField(fieldName, isEqualTo: value).getDocuments()
        return snapshot
        
    }
    
    private func getDocument(collectionName: Firestore_Colecctions, documentID: String) async throws -> DocumentSnapshot {
        
        let ref = db.collection(collectionName.rawValue).document(documentID)
        let snapshot = try await ref.getDocument()
        return snapshot
    }
    
    private func registerNewItem(collectionName: Firestore_Colecctions, data: [String: Any], documentId: String? = nil) async throws -> DocumentReference?{
       
        if let docId = documentId {
            let Itemref = db.collection(collectionName.rawValue).document(docId)
             try await Itemref.setData(data, merge: true)
            return Itemref
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection(collectionName.rawValue).addDocument(data: data) { err in
                if let err = err {
                    print("!! Error adding \(collectionName.rawValue) document: \(err)")
                } else {
                    print("- \(collectionName.rawValue) Document added with ID: \(ref!.documentID)")
                    //self.addGameToCollection(gameRef: ref!, gameCollection: gameCollection, completion: completion)
                }
            }
            return ref
        }
        
    }
    
    func getGameInfo(documentID: String) async -> [String: Any]?{
        do {
            let docSnapshot = try await getDocument(collectionName: .juegos, documentID: documentID)
           // if snapshot.count > 0 {
            if docSnapshot.exists {
                return docSnapshot.data()
            }
                //return snapshot.documents.first?.reference
           // }
        } catch (let err){
            print("Error getting game document: \(err)")
        }
        return nil
    }
    
    func findGame(byExternalId extId: Int) async -> DocumentReference? {
        do {
            let snapshot = try await query(collectionName: .juegos, fieldName: "igdbID", value: extId)
           // if snapshot.count > 0 {
                return snapshot.documents.first?.reference
           // }
        } catch (let err){
            print("Error getting game document: \(err)")
        }
        return nil
    }
    
    func createGame(game: FeaturedGame) async -> DocumentReference?{
        let game_data: [String: Any] = [
            "igdbID": game.dbIdentifier,
            "imagenUrl": game.imageUrl,
            "nombre": game.name
        ]
        
        do {
            let ref = try await registerNewItem(collectionName: .juegos, data: game_data)
            return ref
        }catch (let err){
            print("Error saving game document: \(err)")
        }
        return nil
    }
    
    func queryCollectionReference(gameReference gameRef: DocumentReference) async throws -> DocumentReference?{
        let collectionSnapshot = try await db.collection(Firestore_Colecctions.coleccion.rawValue)
            .whereField("juego", isEqualTo: gameRef)
            .whereField("usuario", isEqualTo: userReference)
            .getDocuments()
        print("Collection fetched: \(collectionSnapshot.documents.first?.description ?? "NULL")")
        return collectionSnapshot.documents.first?.reference
    }
    
    func queryUserCollections() async throws -> Array<[String: Any]>{
        var collections: [[String: Any]] = []
        let collectionSnapshot = try await db.collection(Firestore_Colecctions.coleccion.rawValue)
            .whereField("usuario", isEqualTo: userReference)
            .getDocuments()
        
        for document in collectionSnapshot.documents {
            var collectionItem: [String: Any] = [:]
            //print("--->")
            //print("\(document.documentID) => \(document.data())")
            collectionItem["categoria"] = (document.get("categoria") as? Int) ?? -1
            collectionItem["colleccion"] = document.get("nombre") as? String ?? "NONAME"
            let gameRef = document.get("juego") as? DocumentReference
            
            var gameData: [String : Any] = [:]
            if let gameDoc = try await gameRef?.getDocument(){
                gameData["externalID"] = gameDoc.get("igdbID") as? Int ?? 0
                gameData["cover-url"] = gameDoc.get("imagenUrl") as? String ?? ""
                gameData["nombre"] = gameDoc.get("nombre") as? String ?? ""
                gameData["docid"] = gameRef?.documentID
                collectionItem["juego"] = gameData
            }
            
            collections.append(collectionItem)
        }
        
        return collections
    }
    
    
    func queryCollectionInfo(gameReference gameRef: DocumentReference) async throws -> [String : Any]?{
        guard let collectionReference = try await queryCollectionReference(gameReference: gameRef) else {
            return nil
        }
        
        let snapCollection = try await collectionReference.getDocument()
        let colName = snapCollection.get("nombre") as? String
        let colCat = snapCollection.get("categoria") as? Int
        if let name = colName, let categoria = colCat {
            print("\(categoria) \(name)")
            let collInfo: [String : Any]  = ["name": name,
                            "category": categoria]
            return collInfo
        }
        
        return nil
    }
    
    func addGameToCollection(documentID docID: String, gameCollection: GameCollectionModel) async -> DocumentReference?{
        let gameDocReference = db.collection(Firestore_Colecctions.juegos.rawValue).document(docID)
        return await addGameToCollection(gameReference: gameDocReference, gameCollection: gameCollection)
    }
    func addGameToCollection(gameReference gameRef: DocumentReference, gameCollection: GameCollectionModel) async -> DocumentReference?{
        let colleccionData: [String: Any] = [
            "categoria": gameCollection.index,
            //"juego": db.document("juegos/\(gameRef.documentID)"),
            "juego" : gameRef,
            "nombre": gameCollection.name,
            //"usuario" : db.document("usuarios/\(Auth.auth().currentUser!.uid)")
            "usuario" : userReference
        ]
        
        do {
            print("Queryng collection...")
            if let collRef = try await queryCollectionReference(gameReference: gameRef) {
                print("Existing reference. Updating data...")
                try await collRef.updateData(colleccionData)
                return collRef
            } else {
                print("Creating new entry to collection...")
                let r = try await registerNewItem(collectionName: .coleccion, data: colleccionData)
                
                if r != nil {
                    print("registry suceess")
                } else {
                    print("registry failed")
                }
                return r
            }
        } catch (let err){
            print("Error saving collection document: \(err)")
            return nil
        }
    }
    
    func removeGameFromCollection(gameID: Int) async throws {
        if let gameRef = await findGame(byExternalId: gameID){
            try await removeGameFromCollection(gameReference: gameRef)
        }
    }
    func removeGameFromCollection(gameReference: DocumentReference) async throws {
        let collectionsReference = db.collection(Firestore_Colecctions.coleccion.rawValue)
        if let queryCollection = try await collectionsReference
            .whereField("juego", isEqualTo: gameReference)
            .whereField("usuario", isEqualTo: userReference).getDocuments().documents.first{
            try await collectionsReference.document(queryCollection.documentID).delete()
        }
        
    }
}

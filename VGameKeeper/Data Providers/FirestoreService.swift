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
    
    private func query(collectionName: Firestore_Colecctions, fieldName: String, value: Any) async throws ->  QuerySnapshot {
        
        let snapshot = try await db.collection(collectionName.rawValue).whereField(fieldName, isEqualTo: value).getDocuments()
        return snapshot
        
        /*db.collection(collectionName).whereField(fieldName, isEqualTo: value).getDocuments { snapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
            }
        }*/
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
    
    func queryCollectionReference(gameReference gameRef: DocumentReference, gameCollection: GameCollectionModel) async throws -> DocumentReference?{
        let collectionSnapshot = try await db.collection(Firestore_Colecctions.coleccion.rawValue)
            .whereField("juego", isEqualTo: gameRef)
            .whereField("usuario", isEqualTo: userReference)
            .getDocuments()
        print("Collection fetched: \(collectionSnapshot.documents.first?.description ?? "NULL")")
        return collectionSnapshot.documents.first?.reference
    }
    
    func addGameToCollection(gameReference gameRef: DocumentReference, gameCollection: GameCollectionModel) async -> Bool{
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
            if let collRef = try await queryCollectionReference(gameReference: gameRef, gameCollection: gameCollection) {
                print("Existing reference. Updating data...")
                try await collRef.updateData(colleccionData)
                return true
            } else {
                print("Creating new entry to collection...")
                let r = try await registerNewItem(collectionName: .coleccion, data: colleccionData)
                
                if r != nil {
                    print("registry suceess")
                } else {
                    print("registry failed")
                }
                return true
            }
        } catch (let err){
            print("Error saving collection document: \(err)")
            return false
        }
    }
}

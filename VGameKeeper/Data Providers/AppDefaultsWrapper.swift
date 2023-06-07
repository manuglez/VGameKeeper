//
//  AppDefaultsWrapper.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 01/06/23.
//

import Foundation

class AppDefaultsWrapper {
    static let shared = AppDefaultsWrapper()
    
    private let COLLECTIONS_RELOAD = "COLLECTIONS_RELOAD"
    private let FIRST_RUN_LOAD = "FIRST_RUN_LOAD"
    
    private init() {
        
    }
    
    var firstRunLoad: Bool {
        get {
            return UserDefaults.standard.bool(forKey: FIRST_RUN_LOAD)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: FIRST_RUN_LOAD)
        }
    }
    
    var collectionsReload: Bool {
        get {
            return UserDefaults.standard.bool(forKey: COLLECTIONS_RELOAD)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: COLLECTIONS_RELOAD)
        }
    }
    
}

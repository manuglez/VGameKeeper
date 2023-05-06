//
//  IGDBManager.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 05/05/23.
//

import Foundation
import os.log

class IGDBManager {
    private let logger = Logger()
    
    // Singleton global instance
    static let shared: IGDBManager = IGDBManager()
    
    private init() {
        
    }
    
    static func configure() {
        let client = IGDBConstants.CLIENT_ID
        let secret = IGDBConstants.CLIENT_SECRET
        
        guard client != "" && secret != "" else {
            shared.logger.debug("🚨 No Client-ID or Client-Secret defined in file IGDB-info.plist")
            return
        }
        
        shared.logger.debug("IGDB Client ID: \(client)")
        shared.logger.debug("IGDB Secret: \(secret)")
        
        let auth = IGDBAuth.shared
        if auth.session_token == nil {
            Task {
                shared.logger.debug("🌎 Retrieving new Session Token")
                do {
                    let session = try await auth.retrieveNewToken()
                    shared.logger.debug("ℹ️ Session token received \(session)")
                }catch IGDBAuthError.invalidGrantType(let msg) {
                    shared.logger.debug("🚨  IGDBAuthError.invalidGrantType Token Service error: \(msg)")
                }catch IGDBAuthError.responseParseError(let msg) {
                    shared.logger.debug("🚨  IGDBAuthError.responseParseError Token Service error: \(msg)")
                }catch IGDBAuthError.serverError(let msg) {
                    shared.logger.debug("🚨  IGDBAuthError.serverError Token Service error: \(msg)")
                }catch IGDBAuthError.unknownErrorCode(let msg) {
                    
                    shared.logger.debug("🚨  IGDBAuthError.unknownErrorCode Token Service error: \(msg)")
                }
                catch {
                    shared.logger.debug("🚨 Token Service error: \(error.localizedDescription)")
                }
            }
            
        } else {
            shared.logger.debug("👍 Session Token Founded!!!")
        }
    }
}

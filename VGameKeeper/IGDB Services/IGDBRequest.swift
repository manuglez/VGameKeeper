//
//  IGDBRequest.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 06/05/23.
//

import Foundation
import os.log

class IGDBRequest {
    
    func performPostRequest(urlString: String) async throws -> Data? {
        return try await performPostRequest(urlString: urlString, rawBody: "")
    }
    
    func performPostRequest(urlString: String, rawBody: String) async throws -> Data? {
        let url = URL(string: urlString)
        var urlRequest = URLRequest.init(url: url!)
        let logger =  Logger()
        
        guard let accesToken = IGDBAuth.shared.session_token else {
            logger.debug("🚨 Cannot perform request. No access token defined")
            return nil
        }
        
        let client_id = IGDBConstants.CLIENT_ID
        guard client_id != "" else {
            logger.debug("🚨 No Client-ID defined in file IGDB-info.plist")
            return nil
        }
        
        if rawBody != "" {
            urlRequest.httpBody = rawBody.data(using: .utf8, allowLossyConversion: false)
        }
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(client_id, forHTTPHeaderField: "Client-ID")
        urlRequest.setValue("Bearer \(accesToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let (responseData, _) = try await URLSession.shared.data(for: urlRequest)
        
        return responseData
    }
    
    
}

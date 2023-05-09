//
//  IGDBAuth.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 05/05/23.
//

import Foundation

class IGDBAuth {
    
    static let shared: IGDBAuth = IGDBAuth()
    
    private let USER_DEFAULT_TOKEN_KEY = "IGDB_TOKEN"
    
    internal var pendingToken: Bool = false
    
    private init() {
        
    }
    
    var session_token: String? {
        get {
            let user_defaults = UserDefaults.standard
            return user_defaults.string(forKey: USER_DEFAULT_TOKEN_KEY)
        }
        
        set (newValue){
            let user_defaults = UserDefaults.standard
            user_defaults.set(newValue, forKey: USER_DEFAULT_TOKEN_KEY)
        }
    }
    
    func retrieveNewToken() async throws -> String {
        let urlString = "\(IGDBConstants.AuthBaseUrl)?client_id=\(IGDBConstants.CLIENT_ID)&client_secret=\(IGDBConstants.CLIENT_SECRET)&grant_type=client_credentials"//client_credentials
        print("Auth URL: \(urlString)")
        
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url )
        urlRequest.httpMethod = "POST"
       
        pendingToken = true
        let (responseData, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = urlResponse as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:
                if let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: responseData) {
                    let access_token = tokenResponse.accessToken
                    self.session_token = access_token
                    pendingToken = false
                    return access_token
                    
                } else {
                    if let errorResponse = try? JSONDecoder().decode(IGDBAuthErrorResponse.self, from: responseData) {
                        throw IGDBAuthError.serverError(message: errorResponse.message)
                    } else {
                        throw IGDBAuthError.unknownErrorCode(message: "unknown message")
                    }
                }
                
            case 400:
                throw IGDBAuthError.invalidGrantType(message: "invalid grant type")
            default:
                throw IGDBAuthError.unknownErrorCode(message: "unknown message")
            }
        }
        //let respString = String(data: responseData, encoding: .utf8)
        //print("response: \(respString ?? "NO RESPONSE")")
        
        //let welcome = try? JSONDecoder().decode(AuthResponse.self, from: responseData)
        
        /*
         {"status":400,"message":"invalid grant type"}
         {"access_token":"c993q59kyaqwkq9vlf92eftve41yq5","expires_in":5379594,"token_type":"bearer"}
         {"access_token":"46otf0gyg7e1424lteinddmfiuw76v","expires_in":4757876,"token_type":"bearer"}
         */
        print("End of function")
        return ""
    }

}

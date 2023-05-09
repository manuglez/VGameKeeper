//
//  AuthResponse.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 05/05/23.
//

import Foundation

// MARK: - Welcome
struct IGDBAuthErrorResponse: Codable {
    let status: Int
    let message: String
}

struct TokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

enum IGDBAuthError: Error {
    case invalidGrantType(message: String)
    case serverError(message: String)
    case responseParseError(message: String)
    case unknownErrorCode(message: String)
}

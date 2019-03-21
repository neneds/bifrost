//
//  AccessToken.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

enum TokenType: String, ModelType {
    case jwt
    case oauth
    case other
}

struct AccessToken: ModelType {
    var accessToken: String
    var tokenType: TokenType
    var refreshToken: String?
    var expirationDate: Date?
    var issueDate: Date?
    var scope: String?
    
    init(tokenType: TokenType, accessToken: String, scope: String?, refreshToken: String?) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
        self.refreshToken = refreshToken
        handleTokenType(tokenType, accessToken: accessToken)
    }
    
    private mutating func handleTokenType(_ type: TokenType, accessToken: String) {
        switch type {
        case .jwt:
            let decodedJWT = JWTParser(tokenString: accessToken)
            self.expirationDate = decodedJWT.expiresAt
            self.issueDate = decodedJWT.issuedAt
        default:
            break
        }
    }
}

//
//  AccessTokenService.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation

public final class AccessTokenService {
    private var keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func saveAccessToken(_ accessToken: AccessToken) throws {
        try self.keychainService.set(accessToken.accessToken, key: "access_token")
        try self.keychainService.set(accessToken.tokenType.rawValue, key: "token_type")
    }
    
    func loadAccessToken() throws -> AccessToken? {
        guard let accessToken = try self.keychainService.get("access_token"),
            let tokenType = try self.keychainService.get("token_type")
            else { return nil }
        return AccessToken(tokenType: TokenType(rawValue: tokenType) ?? .other, accessToken: accessToken, scope: nil, refreshToken: "")
    }
    
    func deleteAccessToken() throws {
        try self.keychainService.remove("access_token")
        try self.keychainService.remove("token_type")
    }
}

//
//  AccessTokenService.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation

final class AccessTokenService {
    private var keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func saveAccessToken(_ accessToken: AccessToken) throws {
        try self.keychainService.set(accessToken.accessToken, key: "access_token")
        try self.keychainService.set(accessToken.tokenType, key: "token_type")
        try self.keychainService.set(accessToken.scope, key: "scope")
    }
    
    func loadAccessToken() throws -> AccessToken?  {
        guard let accessToken = try self.keychainService.get("access_token"),
            let tokenType = try self.keychainService.get("token_type"),
            let scope = try self.keychainService.get("scope")
            else { return nil }
        return AccessToken(accessToken: accessToken, tokenType: tokenType, scope: scope, refreshToken: "")
    }
    
    func deleteAccessToken() throws {
        try self.keychainService.remove("access_token")
        try self.keychainService.remove("token_type")
        try self.keychainService.remove("scope")
    }
}

//
//  UserSession.swift
//  Bifrost
//
//  Created by Dennis Merli on 20/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation

enum AuthProvider {
    case basic
    case oauth
    case social
    case none
}

struct User {
    var authProvider: AuthProvider
    var token: AccessToken
}

protocol UserSessionType {
    var isUserLoggedIn: Bool { get }
    func loadSession() throws
    func saveSession(token: AccessToken) throws
    func logOut() throws
}

class UserSession: UserSessionType {
    private(set) var keychainService: KeychainService
    private(set) var accessTokenService: AccessTokenService
    private(set) var currentAccessToken: AccessToken?
    
    init(keychainService: KeychainService, accessTokenService: AccessTokenService) {
        self.keychainService = keychainService
        self.accessTokenService = accessTokenService
    }
    
    var isUserLoggedIn: Bool {
        return currentAccessToken != nil
    }
    
    func logOut() throws {
        try accessTokenService.deleteAccessToken()
    }
    
    func loadSession() throws {
        currentAccessToken = try accessTokenService.loadAccessToken()
    }
    
    func saveSession(token: AccessToken) throws {
        try accessTokenService.saveAccessToken(token)
        currentAccessToken = token
    }
}

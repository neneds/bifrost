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
    func signIn()
    func logOut()
}

class UserSession: UserSessionType {

    private(set) var keychainService: KeychainService
    private(set) var accessTokenService: AccessTokenService
    
    init(keychainService: KeychainService, accessTokenService: AccessTokenService) {
        self.keychainService = keychainService
        self.accessTokenService = accessTokenService
    }
    
    var isUserLoggedIn: Bool {
        return false
    }
    
    func logOut() {
        try? accessTokenService.deleteAccessToken()
    }
    
    func signIn() {
        
    }
    
}

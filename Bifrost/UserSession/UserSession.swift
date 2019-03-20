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

struct Token {
    
}

struct User {
    var authProvider: AuthProvider
    var token: Token
    var refreshToken: String
}


protocol UserSessionType {
    var isUserLoggedIn: Bool { get }
    func clearSessionCredentials()
    
}

class UserSession {
    
}

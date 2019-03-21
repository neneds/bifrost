//
//  AccessToken.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation


struct AccessToken: ModelType {
    var accessToken: String
    var tokenType: String
    var refreshToken: String
    var scope: String
    
    init(accessToken: String, tokenType: String, scope: String, refreshToken: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
        self.refreshToken = refreshToken
    }
}

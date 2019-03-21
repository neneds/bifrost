//
//  ClientCredentials.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

struct ClientCredentials {
    var clientID: String
    var clientSecret: String
    var accessTokenURL: URL
    var parameters: [String: Any]
}

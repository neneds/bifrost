//
//  ClientCredentials.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//
protocol ClientCredentialsType {
    var clientID: String { get set }
    var clientSecret: String { get set }
    var baseAccessCodeURL: URL { get set }
    var fullAccessCodeURL: URL { get }
    var baseTokenRequestURL: URL { get set }
    var tokenRequestParameters: [String: Any] { get }
}

struct ClientCredentials {
    var clientID: String
    var clientSecret: String
    var accessTokenURL: URL
    var parameters: [String: Any]
}

//Request access

//https://www.facebook.com/v3.2/dialog/oauth?
//client_id={app-id}
//&redirect_uri={redirect-uri}
//&state={state-param}

//https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow

//Request token

//GET https://graph.facebook.com/v3.2/oauth/access_token?
//client_id={app-id}
//&redirect_uri={redirect-uri}
//&client_secret={app-secret}
//&code={code-parameter}


struct FacebookClientCredentials: ClientCredentialsType {
    var clientID: String
    
    var clientSecret: String
    
    var baseAccessCodeURL: URL = URL(string: "https://www.facebook.com/v3.2/dialog/oauth")!
    
    var fullAccessCodeURL: URL 
    
    var baseTokenRequestURL: URL
    
    var tokenRequestParameters: [String : Any] {
        return ["client_id": clientID, "redirect_uri" : redirectURI, "state" : state, "response_type" : "code"]
    }
    
    var redirectURI: String
    
    var state: String
    
}

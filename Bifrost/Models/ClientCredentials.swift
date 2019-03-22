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
    var accessCodeURLComponents: URLComponents? { get set }
    var accessCodeURL: URL? { get }
    var tokenRequestURLComponents: URLComponents? { get set }
    mutating func tokenRequestURL(code: String) throws -> URL?
}

struct ClientCredentials: ClientCredentialsType {
    var clientID: String
    
    var clientSecret: String
    
    var accessCodeURLComponents: URLComponents?
    
    var accessCodeURL: URL?
    
    var tokenRequestURLComponents: URLComponents?
    
    mutating func tokenRequestURL(code: String) throws -> URL? {
        tokenRequestURLComponents?.queryItems?.append(URLQueryItem(name: "code", value: code))
        return try tokenRequestURLComponents?.asURL()
    }
}

// Reference: https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow

struct FacebookClientCredentials: ClientCredentialsType {
    var tokenRequestURLComponents: URLComponents?
    var accessCodeURLComponents: URLComponents?
    var graphAPIVersion: String = "v3.2"
    var clientID: String
    var clientSecret: String
    var accessCodeURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.facebook.com"
        urlComponents.path = "/\(graphAPIVersion)/dialog/oauth"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "response_type", value: "code")
        ]
        
        return try? urlComponents.asURL()
    }
    
    func tokenRequestURL(code: String) throws -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "graph.facebook.com"
        urlComponents.path = "/\(graphAPIVersion)/dialog/oauth/access_token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        return try urlComponents.asURL()
    }
    
    var tokenRequestParameters: [String : Any] {
        return ["client_id": clientID, "redirect_uri" : redirectURI, "state" : state, "response_type" : "code"]
    }
    
    var redirectURI: String
    
    var state: String
    
}

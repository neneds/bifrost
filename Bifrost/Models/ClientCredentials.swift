//
//  ClientCredentials.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//


public protocol ClientCredentialsType {
    var clientID: String { get set }
    var clientSecret: String { get set }
    var accessCodeURLComponents: URLComponents? { get set }
    var accessCodeURL: URL? { get }
    var tokenRequestURLComponents: URLComponents? { get set }
    mutating func tokenRequestURL(code: String) throws -> URL?
}

public struct ClientCredentials: ClientCredentialsType {
    public var clientID: String
    
    public var clientSecret: String
    
    public var accessCodeURLComponents: URLComponents?
    
    public var accessCodeURL: URL?
    
    public var tokenRequestURLComponents: URLComponents?
    
    mutating public func tokenRequestURL(code: String) throws -> URL? {
        tokenRequestURLComponents?.queryItems?.append(URLQueryItem(name: "code", value: code))
        return try tokenRequestURLComponents?.asURL()
    }
}

// Reference: https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow

public struct FacebookClientCredentials: ClientCredentialsType {
    public var tokenRequestURLComponents: URLComponents?
    public var accessCodeURLComponents: URLComponents?
    var graphAPIVersion: String = "v3.2"
    public var clientID: String
    public var clientSecret: String
    public var accessCodeURL: URL? {
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
    
    public func tokenRequestURL(code: String) throws -> URL? {
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
    
    var redirectURI: String
    
    var state: String
    
}

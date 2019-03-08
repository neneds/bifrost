//
//  JWTSignUPService.swift
//  Bifrost
//
//  Created by Dennis Merli on 08/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation
import Moya

typealias SignUpCompletion = (_ jsonResponse: [String: Any]?, _ error: Error?) -> Void

protocol SignUPServiceType {
    func signUp(username: String, password: String, completion: @escaping SignUpCompletion)
    func forgotPassword(email: String)
}

class JWTSignUPService: SignUPServiceType {
    
    private(set) var provider: MoyaProvider<SignUPProvider> = MoyaProvider<SignUPProvider>()
    
    func signUp(username: String, password: String, completion: @escaping SignUpCompletion) {
        provider.request(.signUp(username: username, password: password)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    if let jsonResponse: [String : Any] = try moyaResponse.mapJSON() as? [String: Any] {
                       completion(jsonResponse , nil)
                    } else {
                       completion(nil, CustomError.cannotParse())
                    }
                } catch {
                    completion(nil, CustomError.errorFromResponse(with: moyaResponse))
                }
                
            case let .failure(error):
                completion(nil, CustomError.errorFromMoya(with: error))
            }
        }
    }

    func forgotPassword(email: String) {
        
    }
}

enum SignUPProvider {
    case signUp(username: String, password: String)
}

extension SignUPProvider: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .signUp(_, _):
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp(_, _):
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .signUp(_, _):
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let username, let password):
            return .requestParameters(parameters: ["username": username, "password": password], encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

extension SignUPProvider: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        return .bearer
    }
}


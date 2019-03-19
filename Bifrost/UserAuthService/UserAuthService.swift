//
//  JWTSignUPService.swift
//  Bifrost
//
//  Created by Dennis Merli on 08/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation
import Moya

typealias ResponseCompletion = (_ responseObject: Any?, _ error: Error?) -> Void
typealias DecodingParameters<T: Decodable> = (decoder: JSONDecoder, type: T.Type)

protocol SignUpServiceType {
    func signIn<T>(decodingParameters: DecodingParameters<T>?, completion: @escaping ResponseCompletion)
    func signUp<T>(decodingParameters: DecodingParameters<T>?, completion: @escaping ResponseCompletion)
    func forgotPassword<T>(decodingParameters: DecodingParameters<T>?, completion: @escaping ResponseCompletion)
}

struct BaseTarget: TargetType {
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var sampleData: Data
    var task: Task
    var headers: [String : String]?
    
    init(url: URL, path: String, method: Moya.Method, sampleData: Data?, task: Task, headers: [String : String]?) {
        self.baseURL = url
        self.path = path
        self.method = method
        self.sampleData = sampleData ?? Data()
        self.task = task
        self.headers = headers
    }
}

class UserAuthService {
    
    let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var signUpTarget: MultiTarget?
    var signInTarget: MultiTarget?
    var forgotPassTarget: MultiTarget?
    
    
    init(signUpTarget: MultiTarget?, signInTarget: MultiTarget?, forgotPasswordTarget: MultiTarget?) {
        self.signInTarget = signInTarget
        self.signUpTarget = signUpTarget
        self.forgotPassTarget = forgotPasswordTarget
    }
    
    fileprivate func request<T>(target: MultiTarget,decodingParameters: DecodingParameters<T>?, completion: @escaping ResponseCompletion) {
        provider.request(target) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    if decodingParameters != nil {
                        self.decodeObjectFromMoya(decodingParameters: decodingParameters, response: moyaResponse, completion: completion)
                    } else {
                        self.decodeJSONFromMoya(response: moyaResponse, completion: completion)
                    }
                } catch {
                    completion(nil, CustomError.errorFromResponse(with: moyaResponse))
                }
                
            case let .failure(error):
                completion(nil, CustomError.errorFromMoya(with: error))
            }
        }
    }
    
    private func decodeObjectFromMoya<T>(decodingParameters: DecodingParameters<T>?, response: Moya.Response, completion: @escaping ResponseCompletion) {
        guard let decodingParameters = decodingParameters else {
            completion(nil, CustomError.nilParameter(parameter: "Decoding parameters"))
            return
        }
        
        do {
            let decodedObject = try decodingParameters.decoder.decode(decodingParameters.type, from: response.data)
            completion(decodedObject, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    private func decodeJSONFromMoya(response: Moya.Response, completion: @escaping ResponseCompletion) {
        do {
            if let jsonResponse: [String : Any] = try response.mapJSON() as? [String: Any] {
                completion(jsonResponse, nil)
            } else {
                completion(nil, CustomError.cannotParse())
            }
        } catch {
            completion(nil,  CustomError.errorFromResponse(with: response))
        }
    }
}

extension UserAuthService: SignUpServiceType {
    func signIn<T>(decodingParameters: (decoder: JSONDecoder, type: T.Type)?, completion: @escaping ResponseCompletion) where T : Decodable {
        guard let signInTarget = signInTarget else {
            completion(nil, CustomError.nilParameter(parameter: "SignInTarget"))
            return
        }
        return request(target: signInTarget, decodingParameters: decodingParameters, completion: completion)
    }
    
    func signUp<T>(decodingParameters: (decoder: JSONDecoder, type: T.Type)?, completion: @escaping ResponseCompletion) where T : Decodable {
        guard let signUPTarget = signUpTarget else {
            completion(nil, CustomError.nilParameter(parameter: "SignUpTarget"))
            return
        }
        return request(target: signUPTarget, decodingParameters: decodingParameters, completion: completion)
    }
    
    func forgotPassword<T>(decodingParameters: (decoder: JSONDecoder, type: T.Type)?, completion: @escaping ResponseCompletion) where T : Decodable {
        guard let forgotPassTarget = forgotPassTarget else {
            completion(nil, CustomError.nilParameter(parameter: "ForgotPassTarget"))
            return
        }
        return request(target: forgotPassTarget, decodingParameters: decodingParameters, completion: completion)
    }
}


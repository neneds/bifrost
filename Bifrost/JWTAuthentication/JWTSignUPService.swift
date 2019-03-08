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
    func signUp(_ target: TargetType, completion: SignUpCompletion)
    func forgotPassword(_ target: TargetType)
}

class JWTSignUPService<T: TargetType>: SignUPServiceType {

    private(set) var provider: MoyaProvider<T>?
    
    init(provider: MoyaProvider<T>) {
        self.provider = provider
    }
    
    func signUp(_ target: TargetType, completion: ([String : Any]?, Error?) -> Void) {
   
    }
    
    func forgotPassword(_ target: TargetType) {
        
    }
    
}

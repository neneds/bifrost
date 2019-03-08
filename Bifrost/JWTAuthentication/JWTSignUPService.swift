//
//  JWTSignUPService.swift
//  Bifrost
//
//  Created by Dennis Merli on 08/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation
import Moya

protocol SignUPServiceType {
    func signUp()
    func forgotPassword()
}

class JWTSignUPService<T: TargetType>: SignUPServiceType {

    private(set) var provider: MoyaProvider<T>?
    
    init(provider: MoyaProvider<T>) {
        self.provider = provider
    }
    
    func signUp() {
        <#code#>
    }
    
    func forgotPassword() {
        <#code#>
    }
    
}

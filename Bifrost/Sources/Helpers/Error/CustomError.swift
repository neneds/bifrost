//
//  CustomError.swift
//
//
//  Created by Dennis Merli on 25/01/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation
import Moya

class CustomError {
    
    class var errorDomain: String {
        return Bundle.main.bundleID
    }
    
    class func unknown() -> NSError {
        return NSError(domain: CustomError.errorDomain,
                       code: 15,
                       userInfo: [NSLocalizedDescriptionKey: BaseLocalizable().defaultErrorDescription])
    }
    
    class func cannotParse() -> NSError {
        return NSError(domain: CustomError.errorDomain, code: 16, userInfo: [NSLocalizedDescriptionKey: BaseLocalizable().cannotParse])
    }
    
    class func networkError(errorCode: Int) -> NSError {
        return NSError(domain: CustomError.errorDomain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: BaseLocalizable().networkError])
    }
    
    class func nilParameter(parameter: String) -> NSError {
        return NSError(domain: CustomError.errorDomain, code: 121, userInfo: [NSLocalizedDescriptionKey: BaseLocalizable().nilParameter(parameter)])
    }
    
    class func otherError(reason: String) -> NSError {
        return NSError(domain: CustomError.errorDomain, code: 126, userInfo: [NSLocalizedDescriptionKey: reason])
    }
}

extension CustomError {
    class func errorFromResponse(with moyaResponse: Response) -> NSError {
        do {
            guard let data: [String: AnyObject]  = try moyaResponse.mapJSON() as? [String: AnyObject] else {
                return networkError(errorCode: 0)
            }
            
            let domain = moyaResponse.request?.url?.absoluteString
            let status = data["status"] as? Int
            let message = data["message"] as? String
            
            return NSError(domain: domain ?? CustomError.errorDomain,
                           code: status ?? 0,
                           userInfo: [NSLocalizedDescriptionKey: message ?? BaseLocalizable().defaultErrorDescription])
        } catch {
            return CustomError.unknown()
        }
    }
    
    class func errorFromMoya(with moyaError: MoyaError) -> NSError {
        switch moyaError {
        case .underlying(let underlyingError, _):
            if underlyingError.isNetworkConnectionError() {
                return networkError(errorCode: 0)
            } else {
                return networkError(errorCode: 0)
            }
        default:
            return networkError(errorCode: 0)
        }
    }
}

extension Error {
    func isNetworkConnectionError() -> Bool {
        if let error = self as NSError? {
            let networkErrors = [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut, NSURLErrorCannotConnectToHost]
            if networkErrors.contains(error.code) {
                return true
            }
            return false
        }
        return false
    }
}

//
//  JWTParser.swift
//  Bifrost
//
//  Created by Dennis Merli on 21/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

class JWTParser {
    
    private(set) var tokenString: String
    private(set) var header: [String: Any] = [:]
    private(set) var payload: [String: Any] = [:]
    private(set) var signature: String  = ""
    private(set) var expiresAt: Date?
    private(set) var issuedAt: Date?
    
    var isValid: Bool {
        if let expDate = expiresAt {
            return expDate > Date()
        }
        return false
    }
    
    init(tokenString: String) {
        self.tokenString = tokenString
        decode(tokenString)
    }
    
    private func decode(_ token: String) {
        let parts = token.components(separatedBy: ".")
        if parts.count == 3 {
            header = dictionary(from: parts[0])
            payload = dictionary(from: parts[1])
            
            if let exp = payload["iat"] as? TimeInterval {
                issuedAt = Date(timeIntervalSince1970: exp)
            }
            if let exp = payload["exp"] as? TimeInterval {
                expiresAt = Date(timeIntervalSince1970: exp)
            }
            signature = parts[2]
        }
    }
    
    private func dictionary(from string: String?) -> [String: Any] {
        if let unwrappedString = string, let data = base64decode(unwrappedString) {
            if let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                return dic as? [String: Any] ?? [:]
            }
        }
        return [:]
    }
}

extension JWTParser {
    /// URI Safe base64 encode
    fileprivate func base64encode(_ input: Data) -> String {
        let data = input.base64EncodedData(options: NSData.Base64EncodingOptions.lineLength64Characters)
        let string = String(data: data, encoding: .utf8)!
        return string
            .replacingOccurrences(of: "+", with: "-", options: NSString.CompareOptions.caseInsensitive, range: nil)
            .replacingOccurrences(of: "/", with: "_", options: NSString.CompareOptions.caseInsensitive, range: nil)
            .replacingOccurrences(of: "=", with: "", options: NSString.CompareOptions.caseInsensitive, range: nil)
    }
    
    /// URI Safe base64 decode
    fileprivate func base64decode(_ input: String) -> Data? {
        let rem = input.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }
        
        let base64 = input
            .replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
            .replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.caseInsensitive, range: nil) + ending
        
        return Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))
    }
    
}

//
//  Bundle+Extensions.swift
//  Bifrost
//
//  Created by Dennis Merli on 08/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation

extension Bundle {
    
    var projectDisplayName: String {
        if let name =  object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return name
        } else {
            return "unknown project"
        }
    }
    
    var projectVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "unknown"
        }
    }
    
    var projectBuildVersion: String {
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildVersion
        } else {
            return "unknown"
        }
    }
    
    var bundleID: String {
        guard let bundleId = Bundle.main.bundleIdentifier else { return "" }
        return bundleId
    }
    
    static func loadJSONFromBundle(resourceName: String) -> Data {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        
        return data
    }
}

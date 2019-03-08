//
//  BaseLocalizable.swift
//  Bifrost
//
//  Created by Dennis Merli on 08/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation

class BaseLocalizable: NSObject {
    
    let okTitle: String = NSLocalizedString("Ok",
                                            tableName: "BaseLocalizable",
                                            bundle: Bundle.main,
                                            value: "Ok",
                                            comment: "Ok title")
    
    let cancel: String = NSLocalizedString("Cancel",
                                           tableName: "BaseLocalizable",
                                           bundle: Bundle.main,
                                           value: "Cancel",
                                           comment: "Cancel title")
    
    let error: String = NSLocalizedString("Error",
                                          tableName: "BaseLocalizable",
                                          bundle: Bundle.main,
                                          value: "Error",
                                          comment: "Error title")
    
    let unknownError: String = NSLocalizedString("Unknown Error",
                                                 tableName: "BaseLocalizable",
                                                 bundle: Bundle.main,
                                                 value: "Unknown Error",
                                                 comment: "Unknown Error title")
    
    let defaultErrorDescription: String = NSLocalizedString("Default error",
                                                            tableName: "BaseLocalizable",
                                                            bundle: Bundle.main,
                                                            value: "An error has occurred.",
                                                            comment: "An error has occurred message")
    
    let cannotParse: String = NSLocalizedString("Could not parse",
                                                tableName: "BaseLocalizable",
                                                bundle: Bundle.main,
                                                value: "Could not get the response.",
                                                comment: "Could not parse the response error")
    
    let networkError: String = NSLocalizedString("Network Error",
                                                 tableName: "BaseLocalizable",
                                                 bundle: Bundle.main,
                                                 value: "Network error. Please check your network connection.",
                                                 comment: "Network error message")
    
    func nilParameter(_ parameter: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("The parameter: %@ is null", comment: "message for when a parameter is null"), parameter)
    }
    
}


//
//  URL+Extensions.swift
//  Bifrost
//
//  Created by Dennis Merli on 22/03/19.
//  Copyright © 2019 Dennis Merli. All rights reserved.
//

import Foundation

extension URL {
    func queryParameter(_ name: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == name })?.value
    }
}

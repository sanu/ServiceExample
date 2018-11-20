//
//  Constants.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import Foundation

struct Environment {
    static var baseUrl: URL {
        return URL(string: "https://itunes.apple.com") ?? URL(fileURLWithPath: "")
    }
}

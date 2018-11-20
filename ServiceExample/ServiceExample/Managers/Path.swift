//
//  Path.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import Foundation


enum Path: String {
    
    case search
    case none
    
    var name: String {
        if self == .none { return "" }
        return rawValue
    }
}

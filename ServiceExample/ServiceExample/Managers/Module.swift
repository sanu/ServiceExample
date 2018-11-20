//
//  Module.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import Foundation

enum Module {
    
    case search
    case fetch(searchString: String)
    
    var name: String {
        
        switch self {
        case .search: return "search"
        case .fetch(let searchString): return "fetch\(searchString)"
        }
    }
}

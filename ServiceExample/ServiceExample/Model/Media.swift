//
//  Media.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import ObjectMapper
import Alamofire
import PromiseKit

class MappableObject: Mappable {
    
    required init?(map: Map) {}
    func mapping(map: Map) {}
    
    // to create object without a JSON
    init() {}
}

class Media: MappableObject {
    
    var artistId = ""
    var trackId = ""
    var trackName = ""

    override func mapping(map: Map) {
        artistId <- map["artistId"]
        trackId <- map["trackId"]
        trackName <- map["trackName"]
    }
}


extension Media {
    
    static func loadMediaTypes(keyword: String, entity: String) -> Promise<[Media]> {
        
        return Promise { (resolver) in
            
            
            Router.fetch(keyword: keyword, entity: entity).request(keyPath: "results", with: { (response: DataResponse<[Media]>) in
                
                guard response.error == nil else {
                    let error = NSError(domain: "jjj", code: 120, userInfo: [:])
                    resolver.reject(error)
                    return
                }
                resolver.fulfill(response.value ?? [])
            })
            
//            Router.fetch(keyword: keyword, entity: entity).request { (response: DataResponse<[Media]>) in
//
//                guard response.error == nil else {
//                    let error = NSError(domain: "jjj", code: 120, userInfo: [:])
//                    resolver.reject(error)
//                    return
//                }
//                resolver.fulfill(response.value ?? [])
//            }
        }
    }
}


extension Media {
    
    enum Router: Requestable {

        case fetch(keyword: String, entity: String)
        
        var method: HTTPMethod {
            return .get
        }
        
        var module: Module? {
            return .search
        }

        
        var parameters: Parameters {
            switch self {
                case .fetch(let keyword, let entity):
                    return ["term": keyword, "entity": entity]
            }
        }
        
        var encoding: EncodingType {
            return .queryString
        }
    }
}

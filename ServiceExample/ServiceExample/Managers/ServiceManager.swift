//
//  ServiceManager.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import Alamofire

class ServiceManager {
    
    static let shared = ServiceManager()
    
    var manager: Alamofire.SessionManager
    
    private init() {
        manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    }
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return manager.request(urlRequest)
    }
}

extension ServiceManager {
    
    class ServiceAdapter: RequestAdapter {
        
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            
            //customize headers for the request here
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            return urlRequest
        }
    }
}

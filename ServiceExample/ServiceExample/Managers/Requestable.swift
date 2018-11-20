//
//  Requestable.swift
//  ServiceExample
//
//  Created by Sanu Sathyaseelan on 11/20/18.
//  Copyright © 2018 Sanu. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

protocol Requestable: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var module: Module? { get }
    var path: Path? { get }
    var parameters: Parameters { get }
    var encoding: EncodingType { get }
    
    @discardableResult
    func request(with responseObject: @escaping (DefaultDataResponse) -> Void) -> DataRequest
    
    @discardableResult
    func request<T: BaseMappable>(mapToObject object: T?, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest
    
    @discardableResult
    func request<T: BaseMappable>(keyPath keyPath: String?, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest
    
    @discardableResult
    func request<T: BaseMappable>(with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest
    
    @discardableResult
    func request<T: BaseMappable>(with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest
}

extension Requestable {
    
    // default HTTP Method is get
    var method: HTTPMethod {
        return .get
    }
    
    // just to add nil as default path
    var path: Path? {
        return nil
    }
    
    // default parameters
    var defaultParameters: Parameters? {
        return nil
    }
    
    // just to add nil as default parameter
    var parameters: Parameters? {
        return nil
    }
    
    // default request encoding
    var encoding: EncodingType {
        return .json
    }
    
    var url: URL {
        var url = Environment.baseUrl
        if let module = module, !module.name.isEmpty {
            url = url.appendingPathComponent(module.name)
        }
        
        if let path = path, !path.name.isEmpty {
            url = url.appendingPathComponent(path.name)
        }
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        
        // update timeoutIntervalForRequest from router
        ServiceManager.shared.manager.session.configuration.timeoutIntervalForRequest = 60
        
        var requestParams = parameters
        if let defaultParameters = defaultParameters {
            requestParams = defaultParameters.merging(parameters ?? [:]) { _, custom in custom }
        }
        
        var urlRequest = try URLRequest(url: url, method: method)
        
        switch encoding {
        case .json:
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
            return urlRequest
        case .queryString:
            return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: requestParams)
        case .none:
            return urlRequest
        default:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: requestParams)
        }
    }
    
    @discardableResult
    func request(with responseObject: @escaping (DefaultDataResponse) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).response(completionHandler: responseObject).validateErrors()
    }
    
    @discardableResult
    func request<T: BaseMappable>(mapToObject object: T?, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).responseObject(mapToObject: object, completionHandler: responseObject).validateErrors()
    }
    
    @discardableResult
    func request<T: BaseMappable>(keyPath keypath: String?, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).responseArray(keyPath: keypath, completionHandler: responseArray).validateErrors()
    }
    
    @discardableResult
    func request<T: BaseMappable>(with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).responseObject(completionHandler: responseObject).validateErrors()
    }
    
    @discardableResult
    func request<T: BaseMappable>(with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).responseArray(completionHandler: responseArray).validateErrors()
    }
    
}

public extension Alamofire.Request {
    
    /// Prints the log for the request
    @discardableResult
    func debug() -> Self {
        print(debugDescription)
        return self
    }
}

public extension Alamofire.DataRequest {
    
    @discardableResult
    func validateErrors() -> Self {
        return validate { [weak self] (request, response, data) -> Alamofire.Request.ValidationResult in
            
            let code = response.statusCode
            // log response
            if let responseString = String(data: data ?? Data(), encoding: .utf8) {
                print("Raw Response == \(responseString)")
            }
            
            var result: Alamofire.Request.ValidationResult = .success
            
            let error = NSError(domain: "kkk", code: 100, userInfo: [:])
            
            guard let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any], let json = jsonData  else {
                return .failure(error)
            }
            return result
        }
    }
}

enum EncodingType: String {
    case json = "application/json"
    case queryString
    case none
}


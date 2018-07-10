//
//  APIRouter.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    case weather(city:String)
//    case login(email:String, password:String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .weather:
            return .get
//        case .login:
//            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .weather(let city):
            return "/weather?"+K.APIParameterKey.city + city + "&" + K.APIParameterKey.appid+K.ProductionServer.appID
//        case .login:
//            return "/login"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .weather:
            return nil
            
//        case .login(let email, let password):
//            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        }
    }
    
    enum SomeError: Error {
        case someError
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        guard let url = URL.init(string: K.ProductionServer.baseURL + path) else {
            throw SomeError.someError
        }
        
        var urlRequest = URLRequest(url: url)
        
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}


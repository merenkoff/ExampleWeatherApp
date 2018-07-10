//
//  APIClient.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import Alamofire

class APIClient {
    enum IntParsingError: Error {
        case notParsed
    }
        
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return Alamofire.request(route).responseJSON(completionHandler: { (response) in
            guard let data = response.data else {
                completion(Result<T>.failure(IntParsingError.notParsed))
                
                return
            }
      
            do {
                let codable = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(Result<T>.success(codable))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result<T>.failure(error))
                }
            }
        })

    }
    
    static func weather(city: String, completion:@escaping (Result<City>)->Void) {
        performRequest(route: APIRouter.weather(city: city) , completion: completion)
    }

}


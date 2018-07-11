//
//  APIClient.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit
import Alamofire
import AWSRekognition

/*!
 * @class APIClient singleton for acess a REST API
 */
class APIClient {
    enum IntParsingError: Error {
        case notParsed
        case notSignUp
        case notUser
    }
        
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return Alamofire.request(route).responseJSON(completionHandler: { (response) in
            guard let data = response.data else {
                completion(Result<T>.failure(IntParsingError.notParsed))
                
                return
            }
      
            do {
//                let str = String.init(data: data, encoding: .utf8)
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

    static func signup(face: UIImage, completion:@escaping (Result<User>)->Void) {
        
        let data = UIImagePNGRepresentation(face)
        
        guard let targetImage = AWSRekognitionImage(),
            let sourceImage = AWSRekognitionImage() else {
                return
        }
        
        targetImage.bytes = data
        sourceImage.bytes = data
        
        let rekognition = AWSRekognition.default()
        
        let rekognitionRequest = AWSRekognitionCompareFacesRequest.init()!
        //Saved localy
        rekognitionRequest.sourceImage = sourceImage
        //From local camera
        rekognitionRequest.targetImage = targetImage
        
        rekognitionRequest.similarityThreshold = 50
        
        rekognition.compareFaces(rekognitionRequest) { (response, error) in
            if let _error = error {
                completion(Result.failure(_error))
            } else {
                print("\(response)")
                let user = User(id: 0)
                completion(Result.success(user))
                
                //TODO: Temporary solution before implementing a uploading to S3
                let defaults = UserDefaults.standard
                defaults.set(UIImagePNGRepresentation(face) as! Data, forKey: "SIGNUPFACE")
                defaults.synchronize()
            }
        }
    }
    
    static func login(face: UIImage, completion:@escaping (Result<User>)->Void) {
        
        //TODO: Temporary solution before implementing a uploading to S3
        let defaults = UserDefaults.standard
        
        guard let targetImage = AWSRekognitionImage(),
            let sourceImage = AWSRekognitionImage(),
            let dataOld = defaults.object(forKey: "SIGNUPFACE") as? Data else {
                completion(Result.failure(IntParsingError.notSignUp))
                return
        }
        
        let data = UIImagePNGRepresentation(face)
        targetImage.bytes = data
        
        sourceImage.bytes = dataOld
        
        let rekognition = AWSRekognition.default()
        
        let rekognitionRequest = AWSRekognitionCompareFacesRequest.init()!
        //Saved localy
        rekognitionRequest.sourceImage = sourceImage
        //From local camera
        rekognitionRequest.targetImage = targetImage
        
        rekognitionRequest.similarityThreshold = 50
        
        rekognition.compareFaces(rekognitionRequest) { (response, error) in
            if let _error = error {
                completion(Result.failure(_error))
            } else {
                print("\(response)")
                if let faces = response?.faceMatches, faces.count > 0 {
                    
                    let user = User(id: 0)
                    completion(Result.success(user))
                } else {
                    completion(Result.failure(IntParsingError.notUser))
                }
            }
        }
    }
    
}


//
//  City.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import Foundation

//Temporary class for user
struct User: Codable {
    let id: Int
    
}

extension User {
    enum CodingKeys: String, CodingKey {
        case id
        
    }
}

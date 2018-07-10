//
//  WeatherType.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

struct WeatherType : Codable {
    let id: Int
    let type: String
    let description: String
    
    func isRain() -> Bool {
        if type == "Rain" {
            return true
        }
        
        return false
    }
    
    func isCloudy() -> Bool {
        if type == "Clouds" {
            return true
        }
        
        return false
    }
    
}

extension WeatherType {
    enum CodingKeys: String, CodingKey {
        case id
        case type = "main"
        case description
    }
}


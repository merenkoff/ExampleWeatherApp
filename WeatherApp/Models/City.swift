//
//  City.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
//    let weather: Weather?
}

extension City {
    enum CodingKeys: String, CodingKey {
        case id
        case name
//        case weather = "main"
    }
}

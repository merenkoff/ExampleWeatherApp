//
//  Weather.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

struct Weather : Codable{
    let temp: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Float
    let temp_max: Float
    
    func tempInCelsius() -> Double {
        return temp - K.kelvinConversion
    }
    
    func colorOfWeather() -> UIColor {
        if tempInCelsius() <= -20 {
            return UIColor.blue
        }
        if tempInCelsius() >= 30 {
            return UIColor.red
        }
        
        return UIColor.blue
    }
}

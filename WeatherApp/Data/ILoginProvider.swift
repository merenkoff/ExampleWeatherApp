//
//  City.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

protocol ILoginProvider {
    
    func proceed(face :UIImage, isLogin:Bool) -> Void;
    
    //    func numberOfCities() -> Int;
//
//    func getCityWeather(at: Int, completion:@escaping (City)->Void);
    
}

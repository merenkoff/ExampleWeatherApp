//
//  CityDataSource.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

class CityDataSource: NSObject, ICityDataProvider {
    
    var pageData: [String] = ["Kiev,ua", "London,uk", "Tallinn", "Prague"]
    
    func numberOfCities() -> Int {
        return pageData.count
    }
    
    func getCityWeather(at: Int, completion: @escaping (City) -> Void) {
        APIClient.weather(city: pageData[at]) { result in
            switch result {
            case .success(let city):
                completion(city)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

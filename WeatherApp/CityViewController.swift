//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var dataObject: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cityNameLabel.text = dataObject
        
        APIClient.weather(city: dataObject) { result in
            switch result {
            case .success(let city):
                print("_____________________________")
                print(city.name)
                
                self.cityNameLabel.text = city.name
                self.temperatureLabel.text = String(format:"%2.2f ˚", city.weather.tempInCelsius())
                self.temperatureLabel.textColor = city.weather.colorOfWeather()
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }


}


//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit
import Reachability

class CityViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!

    var city: City? {
        didSet {
            guard let city = city else {
                return;
            }
            print("_____________________________")
            print(city.name)
            
            self.cityNameLabel.text = city.name
            self.temperatureLabel.text = String(format:"%2.2f ˚", city.weather.tempInCelsius())
            self.temperatureLabel.textColor = city.weather.colorOfWeather()
            
            if city.isRain() {
                //First priority
                self.weatherImage.image = UIImage.init(named: "rain")
            } else if city.isCloudy() {
                self.weatherImage.image = UIImage.init(named: "cloud")
            } else {
                self.weatherImage.image = nil
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupWeatherUpdater() {
        
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection != .none {
                
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.temperatureLabel.text = "No internet!"
            self.weatherImage.image = nil
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.cityNameLabel.text = dataObject
        
//        setupWeatherUpdater()
        
    }


}


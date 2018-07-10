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
        willSet {
            guard let _city = newValue else {
                return;
            }
            print("_____________________________")
            print(_city.name)
//            Main() {
                self.cityNameLabel.text = _city.name
                self.temperatureLabel.text = _city.readableTemperature()
                self.temperatureLabel.textColor = _city.weather.colorOfWeather()
                
                if _city.isRain() {
                    //First priority
                    self.weatherImage.image = UIImage.init(named: "rain")
                } else if _city.isCloudy() {
                    self.weatherImage.image = UIImage.init(named: "cloud")
                } else {
                    self.weatherImage.image = nil
                }
                
//            }
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


//
//  CityListController.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

class CityListController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
    
    var dataSource : ICityDataProvider? {
        didSet {
            _tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = CityDataSource.shared
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ListOfCities2DetailView",
            let detailViewController = segue.destination as? DetailViewController,
            let selectedCity = sender as? Int else {
                return
        }
        let _ = detailViewController.view
        detailViewController.selectedCity = selectedCity
    }
 
}

extension CityListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ListOfCities2DetailView",
                              sender: indexPath.row)
        }
    }
}

extension CityListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        
        return dataSource.numberOfCities()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Loading ..."
        cell.detailTextLabel?.text = "..."
        
        dataSource?.getCityWeather(at: indexPath.row, completion: { (city) in
            cell.textLabel?.text = city.name
            cell.detailTextLabel?.text = city.readableTemperature()
            cell.detailTextLabel?.textColor = city.weather.colorOfWeather()
        })
        
        return cell
    }
}

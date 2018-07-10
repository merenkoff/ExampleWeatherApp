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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CityListController: UITableViewDelegate {
    
    
}

extension CityListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        
        return dataSource.numberOfCities()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! UITableViewCell
        
        dataSource?.getCityWeather(at: indexPath.row, completion: { (city) in
            cell.textLabel?.text = city.name
        })
        
            
//        cell.deviceIdentifierLabel.text = dataSource[indexPath.row].deviceName()
        return cell
    }
    
    
}

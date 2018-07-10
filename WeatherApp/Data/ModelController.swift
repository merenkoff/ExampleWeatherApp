//
//  ModelController.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    
    var pageControl : UIPageControl?
    
    var dataSource : ICityDataProvider? {
        didSet {
            if let _pageControl = pageControl,
                let _dataSource = dataSource {
                _pageControl.numberOfPages = _dataSource.numberOfCities()
            }
        }
    }

    init(withPageControl : UIPageControl!) {
        super.init()

        pageControl = withPageControl
        
    }

    var indexedControllers = [UIViewController]()
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> CityViewController? {
        guard let dataSource = self.dataSource else {
            return nil
        }
        
        if (dataSource.numberOfCities() == 0) || (index >= dataSource.numberOfCities()) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        
        //TODO: Provide data here
        
        //dataViewController.dataObject = self.pageData[index]
        if indexedControllers.count - 1 < index {
            indexedControllers.append(dataViewController)
        } else {
            indexedControllers[index] = dataViewController
        }
        
        dataSource.getCityWeather(at: index) { (_city) in
            let _ = dataViewController.view
            dataViewController.city = _city
        }
        
        return dataViewController
    }

    func indexOfViewController(_ viewController: CityViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        
        return indexedControllers.index(of: viewController) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! CityViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let dataSource = self.dataSource else {
            return nil
        }
        
        var index = self.indexOfViewController(viewController as! CityViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == dataSource.numberOfCities() {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}


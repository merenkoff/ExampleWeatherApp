//
//  CameraViewController.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import RSLoadingView

class LoginSignupViewController: UIViewController {

    //=============
    // MARK: Outlets
    //=============
    

    //===================
    // MARK: Lazy Loadings
    //===================

}

extension LoginSignupViewController {

    //=================
    // MARK: - Overrides
    //=================

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "LoginView2SignUp") || (segue.identifier == "LoginView2Login") {
            
            guard let cameraViewController = segue.destination as? CameraViewController else {
                return
            }
            
            cameraViewController.delegate = self
            cameraViewController.isLogin = (segue.identifier == "LoginView2Login")
            
        } else {
            guard segue.identifier == "LoginView2ListOfCities",
                let listViewController = segue.destination as? CityListController,
                let user = sender as? User else {
                    return
            }
            
            /*
             *       Provide user to next controller
             */
            
            //listViewController.user = user
        }
        

    }

}

extension LoginSignupViewController : ILoginProvider {
    
    func proceed(face: UIImage, isLogin: Bool) {
        
        let loadingView = RSLoadingView()
        DispatchQueue.main.async {
            loadingView.show(on: self.view)
        }
        
        let closure: (Result<User>)->Void = { (result) in
            DispatchQueue.main.async {
                RSLoadingView.hide(from: self.view)
                
                switch result {
                case .success(let user):
                    
                    self.performSegue(withIdentifier: "LoginView2ListOfCities",
                                      sender: user)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
        
        if (isLogin == true) {
            APIClient.login (face: face, completion: closure )
        } else {
            APIClient.signup(face: face, completion: closure )
        }
        
        
    }
}

@objc extension LoginSignupViewController {

    //=================
    // MARK: - Selectors
    //=================

//    @IBAction func tapGestureAction(_ sender: Any) {
//        captureAndCropp()
//    }

}

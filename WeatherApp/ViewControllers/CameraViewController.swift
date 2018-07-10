//
//  CameraViewController.swift
//  WeatherApp
//
//  Created by Serhii Merenkov on 7/10/18.
//  Copyright © 2018 Sergei Me. All rights reserved.
//

import UIKit
import AVFoundation
import MFCameraManager

class CameraViewController: UIViewController {

    //=============
    // MARK: Outlets
    //=============
    @IBOutlet weak var cameraView: UIView! {
        didSet {
            cameraView.layer.mask = maskLayer
        }
    }

    //===================
    // MARK: Lazy Loadings
    //===================
    lazy var cameraManager: CameraManager = {
        let this = CameraManager()
        return this
    }()

    lazy var maskLayer: CALayer = {
        let this = CALayer()
        this.backgroundColor = UIColor(red: 0/255,
                                       green: 0/255,
                                       blue: 0/255,
                                       alpha: 0.5).cgColor
        this.addSublayer(rectLayer)
        return this
    }()

    lazy var rectLayer: CAShapeLayer = {
        let this = CAShapeLayer()
        this.fillColor = UIColor.black.cgColor
        this.strokeColor = UIColor.white.cgColor
        return this
    }()

    lazy var rectPath: UIBezierPath = {
        let this = UIBezierPath()
        return this
    }()

    lazy var useFrontTextLayer: CATextLayer = {
        let this = CATextLayer()
        return this
    }()

    lazy var tapHereToCaptureTextLayer: CATextLayer = {
        let this = CATextLayer()
        return this
    }()

}

extension CameraViewController {

    //=================
    // MARK: - Overrides
    //=================
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try cameraManager.captureSetup(in: cameraView, withPosition: .front)
        } catch {
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            alertController.addAction(.init(title: "ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraManager.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopRunning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?
            .interactivePopGestureRecognizer?
            .isEnabled = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cameraManager.transitionCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraManager.updatePreviewFrame()
        drawOverRectView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "CameraView2ListOfCities",
            let imageViewController = segue.destination as? CityListController,
            let image = sender as? UIImage else {
                return
        }
        
//        imageViewController.image = image
    }

}

extension CameraViewController {

    //================
    // MARK: - Methods
    //================
    func captureAndCropp() {
        cameraManager.getImage(croppWith: self.rectLayer.frame) { (croppedImage, _) -> Void in
            guard let croppedImage = croppedImage else {
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "CameraView2ListOfCities",
                                  sender: croppedImage)
            }
        }
    }

    /// this func will draw a rect mask over the camera view
    func drawOverRectView() {

        let cameraSize = self.cameraView.frame.size
        // to calculate the height of frame based on screen size
        let frameHeight: CGFloat
        // to calculate the width of frame based on screen size
        let frameWidth: CGFloat
        // to calculate position Y of recFrame to be in center of cameraView
        let originY: CGFloat
        // to calculate position X of recFrame to be in center of cameraView
        let originX: CGFloat

        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation

        // calculatin position and frame of rectFrame based on screen size
        switch orientation {
        case .landscapeRight, .landscapeLeft:
            frameHeight = (cameraSize.height)/1.4
            frameWidth = cameraSize.width/1.5
        default:
            //if it is faceUp or portrait or any other orientation
            frameHeight = (cameraSize.height)/1.5
            frameWidth = cameraSize.width/1.15
        }
        originY = ((cameraSize.height - frameHeight)/2)
        originX = (cameraSize.width - frameWidth)/2

        //create a rect shape layer
        rectLayer.frame = CGRect(x: originX,
                                 y: originY,
                                 width: frameWidth,
                                 height: frameHeight)

        let bezierPathFrame = CGRect(origin: .zero,
                                     size: rectLayer.frame.size)
        //add beizier to rect shapelayer
        rectLayer.path = UIBezierPath(roundedRect: bezierPathFrame,
                                      cornerRadius: 10)
            .cgPath

        //add shapelayer to layer
        maskLayer.frame = cameraView.bounds
    }

}

@objc extension CameraViewController {

    //=================
    // MARK: - Selectors
    //=================

    @IBAction func tapGestureAction(_ sender: Any) {
        captureAndCropp()
    }

}

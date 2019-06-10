//
//  LaunchAnimationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/2/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol handleStatusBarHide {
    func hideStatusBar()
    func bringStatusBar()
    func lightContentStatusBar()
    func defaultStatusBar()
}

protocol handleSignIn {
    func moveToMainController()
}

var phoneHeight: CGFloat = 0
var phoneWidth: CGFloat = 0
var statusHeight: CGFloat = 0

class LaunchAnimationsViewController: UIViewController, handleStatusBarHide, handleSignIn {
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2 - 60, width: self.view.frame.width, height: 60))
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH0
        label.text = "Welcome"
        view.addSubview(label)
        
        return view
    }()
    
    var logoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        
        return view
    }()
    
    var drivewayzCar: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "drivewayzLogo")
        view.image = image
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.WHITE
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var purpleGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleBlueColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    lazy var startupOnboardingController: OnboardingViewController = {
        let controller = OnboardingViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.statusDelegate = self
        
        return controller
    }()
    
    lazy var startupMapController: TabViewController = {
        let controller = TabViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()

    var drivewayzCarAnchor: NSLayoutConstraint!
    var drivewayzCarTopAnchor: NSLayoutConstraint!
    var startupAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneHeight = self.view.frame.height
        phoneWidth = self.view.frame.width

        self.view.addSubview(purpleGradient)
        purpleGradient.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purpleGradient.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purpleGradient.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        purpleGradient.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(blackView)
        blackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(logoView)
        logoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drivewayzCarTopAnchor = logoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            drivewayzCarTopAnchor.isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        drivewayzCarAnchor = logoView.widthAnchor.constraint(equalToConstant: 62)
            drivewayzCarAnchor.isActive = true
        
        logoView.addSubview(drivewayzCar)
        drivewayzCar.leftAnchor.constraint(equalTo: logoView.leftAnchor).isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 65).isActive = true
        drivewayzCar.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 276).isActive = true
        
        self.checkViews()
        delayWithSeconds(0.6) {
            self.animate()
        }
    }
    
    func animate() {
        UIView.animate(withDuration: animationOut, animations: {
            self.drivewayzCarAnchor.constant = 280
            self.view.layoutIfNeeded()
        }) { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                UIView.animate(withDuration: animationIn, animations: {
                    self.startupAnchor.constant = 0
                    if self.controller == true {
                        self.logoView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.startupMapController.view.alpha = 1
                    } else {
                        switch device {
                        case .iphone8:
                            self.drivewayzCarTopAnchor.constant = -120
                        case .iphoneX:
                            self.drivewayzCarTopAnchor.constant = -160
                        }
                    }
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    if self.controller == true {
                        UIView.animate(withDuration: animationIn, animations: {
                            self.blackView.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    var controller: Bool = false
    
    func checkViews() {
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn == true {
            self.controller = true
            
            self.view.addSubview(startupMapController.view)
            self.addChild(startupMapController)
            startupMapController.willMove(toParent: self)
            startupMapController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            startupAnchor = startupMapController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                startupAnchor.isActive = true
            startupMapController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            startupMapController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            startupMapController.view.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideStatusBar()
                self.defaultStatusBar()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.bringStatusBar()
                self.checkDayTimeStatus()
            }
        } else {
            self.controller = false
            
            self.view.addSubview(startupOnboardingController.view)
            self.addChild(startupOnboardingController)
            startupOnboardingController.willMove(toParent: self)
            startupOnboardingController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.startupAnchor = startupOnboardingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
                self.startupAnchor.isActive = true
            startupOnboardingController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            startupOnboardingController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            startupOnboardingController.view.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideStatusBar()
                self.checkDayTimeStatus()
            }
        }
    }
    
    func moveToMainController() {
        self.controller = true
        
        self.view.addSubview(self.startupMapController.view)
        self.addChild(self.startupMapController)
        self.startupMapController.willMove(toParent: self)
        delayWithSeconds(4) {
            self.startupMapController.mapController.setupLocationManager()
        }
        startupMapController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startupMapController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startupMapController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        startupMapController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        startupMapController.view.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            UIView.animate(withDuration: animationIn, animations: {
                self.startupMapController.view.alpha = 1
                self.blackView.alpha = 1
            }, completion: { (success) in
                self.bringStatusBar()
                self.defaultStatusBar()
            })
        }
    }
    
    func hideStatusBar() {
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func bringStatusBar() {
        statusBarShouldBeHidden = false
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func lightContentStatusBar() {
        self.statusBarColor = true
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func defaultStatusBar() {
        self.statusBarColor = false
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var statusBarShouldBeHidden = true
    var statusBarColor = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarColor == true {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func checkDayTimeStatus() {
        switch solar {
        case .day:
            self.defaultStatusBar()
        case .night:
//            self.lightContentStatusBar()
            self.defaultStatusBar()
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }

}

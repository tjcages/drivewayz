//
//  LaunchAnimationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/2/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import TOMSMorphingLabel

protocol handleStatusBarHide {
    func hideStatusBar()
    func bringStatusBar()
    func lightContentStatusBar()
    func defaultStatusBar()
}

class LaunchAnimationsViewController: UIViewController, handleStatusBarHide {
    
    var morphingLabel: TOMSMorphingLabel = {
        let label = TOMSMorphingLabel()
        label.text = "Drivewayz"
        label.animationDuration = 1.6
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = UIFont.systemFont(ofSize: 40, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var drivewayzCar: UIImageView = {
        let image = UIImage(named: "DrivewayzCar")
        let flip = UIImage(cgImage: (image?.cgImage)!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
        let view = UIImageView(image: flip)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.WHITE
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startupController: SignInViewController = {
        let controller = SignInViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Startup"
        controller.delegate = self
        return controller
    }()
    
    lazy var tabController: TabViewController = {
        let controller = TabViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Tab"
        controller.delegate = self
        return controller
    }()
    
    var drivewayzCarAnchor: NSLayoutConstraint!
    var startupAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let background = CAGradientLayer().startColors()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        self.view.addSubview(drivewayzCar)
        drivewayzCarAnchor = drivewayzCar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.width)
            drivewayzCarAnchor.isActive = true
        drivewayzCar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        self.checkViews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animate()
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.8, animations: {
            self.drivewayzCarAnchor.constant = 0
            self.drivewayzCar.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.view.addSubview(self.morphingLabel)
                self.morphingLabel.topAnchor.constraint(equalTo: self.drivewayzCar.bottomAnchor, constant: -40).isActive = true
                self.morphingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.morphingLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
                self.morphingLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 42).isActive = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.startupAnchor.constant = 0
                        self.drivewayzCar.alpha = 0
                        self.morphingLabel.alpha = 0
                        self.tabController.view.alpha = 1
                        self.startupController.view.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
//                        UIApplication.shared.statusBarStyle = .default
                    })
                }
            }
        }
    }
    
    func checkViews() {
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn == true {
            self.view.addSubview(self.tabController.view)
            self.addChildViewController(self.tabController)
            self.tabController.willMove(toParentViewController: self)
            self.tabController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.startupAnchor = self.tabController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.startupAnchor.isActive = true
            self.tabController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            self.tabController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.tabController.view.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.defaultStatusBar()
            }
        } else {
            self.view.addSubview(self.startupController.view)
            self.addChildViewController(self.startupController)
            self.startupController.willMove(toParentViewController: self)
            self.startupController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.startupAnchor = self.startupController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.startupAnchor.isActive = true
            self.startupController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            self.startupController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.startupController.view.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.lightContentStatusBar()
            }
        }
    }
    
    func hideStatusBar() {
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func bringStatusBar() {
        statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func lightContentStatusBar() {
        self.statusBarColor = true
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func defaultStatusBar() {
        self.statusBarColor = false
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var statusBarShouldBeHidden = false
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
    

}

//
//  LaunchAnimationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/2/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import TOMSMorphingLabel

class LaunchAnimationsViewController: UIViewController {
    
    var morphingLabel: TOMSMorphingLabel = {
        let label = TOMSMorphingLabel()
        label.text = "driveWayz"
        label.animationDuration = 1.2
        label.textAlignment = .center
        label.textColor = Theme.DARK_GRAY
        label.font = UIFont.systemFont(ofSize: 40, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var drivewayzCar: UIImageView = {
        let image = UIImage(named: "DrivewayzCar")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startupController: StartUpViewController = {
        let controller = StartUpViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Startup"
        return controller
    }()
    
    lazy var tabController: TabViewController = {
        let controller = TabViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Tab"
        return controller
    }()
    
    var drivewayzCarAnchor: NSLayoutConstraint!
    var startupAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(drivewayzCar)
        drivewayzCarAnchor = drivewayzCar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            drivewayzCarAnchor.isActive = true
        drivewayzCar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
        drivewayzCar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        drivewayzCar.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        self.checkViews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animate()
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.6, animations: {
            self.drivewayzCarAnchor.constant = -4
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
//                        self.drivewayzCar.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//                        self.morphingLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        self.tabController.view.alpha = 1
                        self.startupController.view.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        UIApplication.shared.statusBarStyle = .default
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
            UIApplication.shared.statusBarStyle = .default
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
            UIApplication.shared.statusBarStyle = .default
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

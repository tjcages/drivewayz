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
    
    var blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var morphingLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivewayz"
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return label
    }()
    
    var drivewayzCar: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "drivewayzLogo")
        view.image = image
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.WHITE
        view.contentMode = .scaleAspectFit
        
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
    
    lazy var purpleGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    let gradientMaskLayer:CAGradientLayer = CAGradientLayer()
    
    var drivewayzCarAnchor: NSLayoutConstraint!
    var startupAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(purpleGradient)
        purpleGradient.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purpleGradient.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purpleGradient.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        purpleGradient.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(self.morphingLabel)
        self.morphingLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20).isActive = true
        self.morphingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.morphingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.morphingLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 42).isActive = true
        
        self.view.addSubview(blackView)
        blackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        let containerView = UIView(frame: CGRect(x: self.view.frame.width/2-120, y: self.view.frame.height/2-120, width: 240, height: 240))
        view.addSubview(containerView)
        
        gradientMaskLayer.frame = containerView.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor, UIColor.red.cgColor, UIColor.clear.cgColor ]
        gradientMaskLayer.startPoint = CGPoint(x: -0.2, y: 0.0)
        gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        drivewayzCar.frame = containerView.bounds
        containerView.addSubview(drivewayzCar)
        drivewayzCar.layer.mask = gradientMaskLayer
        
        self.checkViews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animatee()
        }
    }
    
    func animatee() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 0.2, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 0.4, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 0.6, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 0.8, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.gradientMaskLayer.endPoint = CGPoint(x: 1.2, y: 0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            UIView.animate(withDuration: 0.5, animations: {
                self.drivewayzCar.alpha = 0
                self.tabController.view.alpha = 1
                self.startupController.view.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.blackView.alpha = 1
                })
            })
        }
    }
    
    func checkViews() {
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn == true {
            self.view.addSubview(self.tabController.view)
            self.addChild(self.tabController)
            self.tabController.willMove(toParent: self)
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
            self.addChild(self.startupController)
            self.startupController.willMove(toParent: self)
            self.startupController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.startupAnchor = self.startupController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.startupAnchor.isActive = true
            self.startupController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            self.startupController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.startupController.view.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.defaultStatusBar()
            }
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

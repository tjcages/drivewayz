//
//  LaunchAnimationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/2/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleStatusBarHide {
    func hideStatusBar()
    func bringStatusBar()
    func lightContentStatusBar()
    func defaultStatusBar()
}

protocol handleSignIn {
    func moveToMainController()
}

class LaunchAnimationsViewController: UIViewController, handleStatusBarHide, handleSignIn {
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2 - 60, width: self.view.frame.width, height: 60))
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH0
        label.text = "Welcome"
        view.addSubview(label)
        
        return view
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
    
    lazy var purpleGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var containerView: UIView!
    let gradientMaskLayer: CAGradientLayer = CAGradientLayer()
    
    var drivewayzCarAnchor: NSLayoutConstraint!
    var startupAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        containerView = UIView(frame: CGRect(x: self.view.frame.width/2-110, y: self.view.frame.height/2-110, width: 220, height: 220))
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
            UIView.animate(withDuration: animationIn, animations: {
                if self.controller == false {
                    self.containerView.frame = CGRect(x: self.view.frame.width/2-110, y: (self.view.frame.height-260)/2-110, width: 220, height: 220)
                }
                self.startupAnchor.constant = 0
                if self.tabController != nil {
                    self.tabController!.view.alpha = 1
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
    
    var tabController: TabViewController?
    var controller: Bool = false
    
    func checkViews() {
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn == true {
            self.tabController = TabViewController()
            self.tabController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.tabController!.delegate = self
            
            self.controller = true
            self.view.addSubview(self.tabController!.view)
            self.addChild(self.tabController!)
            self.tabController!.willMove(toParent: self)
            self.tabController!.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.startupAnchor = self.tabController!.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                self.startupAnchor.isActive = true
            self.tabController!.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            self.tabController!.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.tabController!.view.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideStatusBar()
                self.defaultStatusBar()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.bringStatusBar()
            }
        } else {
            let startupController: PhoneVerificationViewController = PhoneVerificationViewController()
            startupController.view.translatesAutoresizingMaskIntoConstraints = false
            startupController.delegate = self
            
            self.controller = false
            self.view.addSubview(startupController.view)
            self.addChild(startupController)
            startupController.willMove(toParent: self)
            startupController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.startupAnchor = startupController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
                self.startupAnchor.isActive = true
            startupController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            startupController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            startupController.view.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideStatusBar()
            }
        }
    }
    
    func moveToMainController() {
        self.tabController = TabViewController()
        self.tabController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.tabController!.delegate = self
        
        self.controller = true
        self.view.addSubview(self.tabController!.view)
        self.addChild(self.tabController!)
        self.tabController!.willMove(toParent: self)
        self.tabController!.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tabController!.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.tabController!.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        self.tabController!.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.tabController!.view.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            UIView.animate(withDuration: animationIn, animations: {
                self.tabController!.view.alpha = 1
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
    

}

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

    var tabController: TabViewController?
    var onboardingController: OnboardingViewController?
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0

        return view
    }()
    var drivewayzBottomIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "DrivewayzBottomIcon")
        view.image = image
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var drivewayzTopIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "DrivewayzTopIcon")
        view.image = image
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var drivewayzLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "drivewayz"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH0
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        label.alpha = 0
        
        return label
    }()
    
    lazy var gradient: UIImageView = {
        let image = UIImage(named: "purpleGradient")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()

    var drivewayzIconLeftAnchor: NSLayoutConstraint!
    var drivewayzIconTopAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkViews()
        
        phoneHeight = self.view.frame.height
        phoneWidth = self.view.frame.width
        
        switch device {
        case .iphone8:
            gradientHeight = 140
            cancelBottomHeight = -32
        case .iphoneX:
            gradientHeight = 160
            cancelBottomHeight = -52
        }

        self.view.addSubview(gradient)
        gradient.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradient.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradient.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradient.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(blackView)
        blackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(drivewayzBottomIcon)
        self.view.addSubview(drivewayzTopIcon)
        drivewayzBottomIcon.centerXAnchor.constraint(equalTo: drivewayzTopIcon.centerXAnchor).isActive = true
        drivewayzBottomIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        drivewayzBottomIcon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        drivewayzBottomIcon.heightAnchor.constraint(equalTo: drivewayzBottomIcon.widthAnchor).isActive = true
        
        drivewayzIconLeftAnchor = drivewayzTopIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            drivewayzIconLeftAnchor.isActive = true
        drivewayzIconTopAnchor = drivewayzTopIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            drivewayzIconTopAnchor.isActive = true
        drivewayzTopIcon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        drivewayzTopIcon.heightAnchor.constraint(equalTo: drivewayzTopIcon.widthAnchor).isActive = true
        
        self.view.addSubview(drivewayzLabel)
        drivewayzLabel.leftAnchor.constraint(equalTo: drivewayzTopIcon.rightAnchor, constant: 12).isActive = true
        drivewayzLabel.centerYAnchor.constraint(equalTo: drivewayzTopIcon.centerYAnchor, constant: 4).isActive = true
        drivewayzLabel.sizeToFit()
        
        delayWithSeconds(0.1) {
            self.animate()
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.15, animations: {
            self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }) { (success) in
            UIView.animate(withDuration: 0.15, animations: {
                self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }) { (success) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }) { (success) in
                        UIView.animate(withDuration: 0.25, animations: {
                            self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                        }) { (success) in
                            UIView.animate(withDuration: 0.25, animations: {
//                                self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            }) { (success) in
                                
                            }
                        }
                    }
                }
            }
        }
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.drivewayzIconTopAnchor.constant = -60
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: 1.4, y: 1.4)
            transform = transform.translatedBy(x: 0.0, y: 8)
            self.drivewayzBottomIcon.transform = transform
            self.drivewayzBottomIcon.alpha = 0.5
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.drivewayzIconTopAnchor.constant = 0
                var transform = CGAffineTransform.identity
                transform = transform.scaledBy(x: 1.0, y: 1.0)
                transform = transform.translatedBy(x: 0.0, y: 0)
                self.drivewayzBottomIcon.transform = transform
                self.drivewayzBottomIcon.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                delayWithSeconds(0.3, completion: {
                    UIView.animate(withDuration: 0.2, animations: {
                        let width = self.drivewayzLabel.text?.width(withConstrainedHeight: 40, font: Fonts.SSPBoldH0)
                        self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: -0.6, y: 0.6)
                        self.drivewayzBottomIcon.transform = CGAffineTransform(scaleX: -0.6, y: 0.6)
                        self.drivewayzIconLeftAnchor.constant = (-108 - width!)/2
                        self.drivewayzTopIcon.alpha = 0
                        self.drivewayzBottomIcon.alpha = 0
                        self.drivewayzLabel.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        delayWithSeconds(0, completion: {
                            UIView.animate(withDuration: animationIn, animations: {
                                if self.controller == true {
                                    self.drivewayzLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.drivewayzTopIcon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.drivewayzBottomIcon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.drivewayzLabel.alpha = 0
                                    self.drivewayzTopIcon.alpha = 0
                                    self.drivewayzBottomIcon.alpha = 0
                                    
                                    let controller = TabViewController()
                                    self.tabController = controller
                                    controller.delegate = self
                                    controller.modalPresentationStyle = .overFullScreen
                                    controller.modalTransitionStyle = .crossDissolve
                                    self.present(controller, animated: true, completion: {
                                        self.defaultStatusBar()
                                        self.bringStatusBar()
                                        UIView.animate(withDuration: animationIn, animations: {
                                            self.blackView.alpha = 1
                                        })
                                    })
                                } else {
                                    self.drivewayzIconTopAnchor.constant = -200
                                    self.drivewayzBottomIcon.transform = CGAffineTransform(translationX: 0.0, y: -200)
                                    self.drivewayzLabel.alpha = 0
                                    self.drivewayzTopIcon.alpha = 0
                                    self.drivewayzBottomIcon.alpha = 0
                                    
                                    let controller = OnboardingViewController()
                                    self.onboardingController = controller
                                    controller.delegate = self
                                    controller.statusDelegate = self
                                    controller.modalPresentationStyle = .overFullScreen
                                    self.present(controller, animated: true, completion: {
                                        self.hideStatusBar()
                                        UIView.animate(withDuration: animationIn, animations: {
                                            controller.circularView.alpha = 1
                                        })
                                    })
                                }
                                self.view.layoutIfNeeded()
                            }, completion: { (success) in
//
                            })
                        })
                    })
                })
            }
        }
    }
    
    var controller: Bool = false
    
    func checkViews() {
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn == true {
            self.controller = true
        } else {
            self.controller = false
        }
    }
    
    func moveToMainController() {
        self.controller = true
        
        self.defaultStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.blackView.alpha = 1
        })
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        delayWithSeconds(1) {
            self.bringStatusBar()
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
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }


}

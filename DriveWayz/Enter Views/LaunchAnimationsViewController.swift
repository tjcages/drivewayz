//
//  LaunchAnimationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/2/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import SVGKit
import CoreLocation

protocol handleStatusBarHide {
    func hideStatusBar()
    func bringStatusBar()
    func lightContentStatusBar()
    func defaultStatusBar()
    
    func backToOnboarding()
}

protocol handleSignIn {
    func moveToMainController()
}

var phoneHeight: CGFloat = 0
var phoneWidth: CGFloat = 0
var statusHeight: CGFloat = 0
var topSafeArea: CGFloat = 0
var bottomSafeArea: CGFloat = 0

class LaunchAnimationsViewController: UIViewController, handleStatusBarHide, handleSignIn {
    
    var drivewayzIcon: SVGKImageView = {
        let image = SVGKImage(named: "DrivewayzLogo_white")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLACK
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        phoneHeight = self.view.frame.height
        phoneWidth = self.view.frame.width
        
        NotificationCenter.default.addObserver(self, selector: #selector(lightContentStatusBar), name: NSNotification.Name(rawValue: "lightContentStatusBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(defaultStatusBar), name: NSNotification.Name(rawValue: "defaultStatusBar"), object: nil)
        
        switch device {
        case .iphone8:
            gradientHeight = 140
            cancelBottomHeight = -8
        case .iphoneX:
            gradientHeight = 160
            cancelBottomHeight = 0
        }
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        
        checkViews()
    }
    
    func setupViews() {
        
        view.addSubview(drivewayzIcon)
        drivewayzIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drivewayzIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        drivewayzIcon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        drivewayzIcon.widthAnchor.constraint(equalTo: drivewayzIcon.heightAnchor).isActive = true
        
    }
    
    func checkViews() {
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn == true {
            let controller = LaunchMainController()
            controller.delegate = self
            controller.tabController.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: false) {
                //
            }
        } else {
            let controller = LaunchOnboardingController()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: false) {
                //
            }
        }
    }
    
    func moveToMainController() {
        defaultStatusBar()
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        delayWithSeconds(1) {
            self.bringStatusBar()
        }
    }
    
    func backToOnboarding() {
        tabDimmingView.alpha = 0
        
        let controller = LaunchOnboardingController()
        controller.delegate = self
        controller.drivewayzIcon_white.alpha = 0
        controller.drivewayzIcon.alpha = 1
        controller.box.backgroundColor = Theme.WHITE
        controller.container.backgroundColor = Theme.WHITE
        controller.view.backgroundColor = Theme.WHITE
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        
        modalTransitionStyle = .crossDissolve
        dismiss(animated: true, completion: nil)
        present(controller, animated: true, completion: nil)
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
    
    @objc func lightContentStatusBar() {
        statusBarColor = true
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc func defaultStatusBar() {
        statusBarColor = false
        UIView.animate(withDuration: animationIn) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var statusBarShouldBeHidden = true
    var statusBarColor = false
    
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

func lightContentStatusBar() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lightContentStatusBar"), object: nil)
}

func defaultContentStatusBar() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "defaultStatusBar"), object: nil)
}

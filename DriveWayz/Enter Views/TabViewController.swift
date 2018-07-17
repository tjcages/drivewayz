//
//  PageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

var rightArrow: UIButton!
var leftArrow: UIButton!

class TabViewController: UITabBarController {
    
    var swipe: Int = 1
    
    lazy var container: UIView = {
        let containerBar = UIView()
        containerBar.translatesAutoresizingMaskIntoConstraints = false
        containerBar.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 1
        let gestureProfile = UISwipeGestureRecognizer(target: self, action: #selector(moveToProfileSwipe(sender:)))
        gestureProfile.direction = .left
        containerBar.addGestureRecognizer(gestureProfile)
        let gestureMap = UISwipeGestureRecognizer(target: self, action: #selector(moveToMapSwipe(sender:)))
        gestureMap.direction = .right
        containerBar.addGestureRecognizer(gestureMap)
        containerBar.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true
        
        let whiteView = UIButton(type: .custom)
        whiteView.backgroundColor = UIColor.white
        whiteView.alpha = 0.5
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.isUserInteractionEnabled = false
        containerBar.insertSubview(whiteView, belowSubview: blurView)
        
        whiteView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        whiteView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true

        return containerBar
    }()
    
    var profile: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "account")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRIMARY_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToProfileTap(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var map: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "notification")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRIMARY_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToMapTap(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var mapController: MapViewController = {
        let controller = MapViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Map"
        return controller
    }()
    
    lazy var accountController: AccountViewController = {
        let controller = AccountViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Profile"
        return controller
    }()
    
    var mapControllerAnchor: NSLayoutConstraint!
    var accountControllerAnchor: NSLayoutConstraint!
    var mapCenterAnchor: NSLayoutConstraint!
    var profileCenterAnchor: NSLayoutConstraint!
    
    var containerLeftAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.addSubview(mapController.view)
        mapControllerAnchor = mapController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        mapControllerAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(accountController.view)
        accountControllerAnchor = accountController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width)
        accountControllerAnchor.isActive = true
        accountController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        accountController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        accountController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(container)
        containerLeftAnchor = container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/3)
            containerLeftAnchor.isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(map)
        map.widthAnchor.constraint(equalToConstant: 50).isActive = true
        map.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mapCenterAnchor = map.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width/2)
            mapCenterAnchor.isActive = true
        map.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        container.addSubview(profile)
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileCenterAnchor = profile.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width*3/4)
            profileCenterAnchor.isActive = true
        profile.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

    }
    
    @objc func moveToProfileTap(sender: UIButton) {
        moveTopProfile()
    }
    
    @objc func moveToProfileSwipe(sender: UITapGestureRecognizer) {
        moveTopProfile()
    }
    
    func moveTopProfile() {
        if mapControllerAnchor.constant == 0 {
//            sendprofile()
            self.containerLeftAnchor.constant = 0
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.statusBarStyle = .lightContent
                self.accountControllerAnchor.constant = 0
                self.mapControllerAnchor.constant = -self.view.frame.width
                self.mapCenterAnchor.constant = self.view.frame.width/4
                self.profileCenterAnchor.constant = self.view.frame.width/2
                self.view.layoutIfNeeded()
            }) { (success) in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.mapController.willMove(toParentViewController: nil)
//                    self.mapController.view.removeFromSuperview()
//                    self.mapController.removeFromParentViewController()
//                }
            }
        }
    }
    
    func sendprofile() {
        
        self.addChildViewController(accountController)
        accountController.didMove(toParentViewController: self)
        
        self.view.addSubview(accountController.view)
        accountControllerAnchor = accountController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width)
        accountControllerAnchor.isActive = true
        accountController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        accountController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        accountController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.view.bringSubview(toFront: container)
    }
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
    }
    
    func moveToMap() {
        if accountControllerAnchor.constant == 0 {
//            sendmap()
            self.containerLeftAnchor.constant = self.view.frame.width/3
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.statusBarStyle = .default
                self.mapControllerAnchor.constant = 0
                self.accountControllerAnchor.constant = self.view.frame.width
                self.mapCenterAnchor.constant = self.view.frame.width/2
                self.profileCenterAnchor.constant = self.view.frame.width*3/4
                self.view.layoutIfNeeded()
            }) { (success) in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.accountController.willMove(toParentViewController: nil)
//                    self.accountController.view.removeFromSuperview()
//                    self.accountController.removeFromParentViewController()
//                }
            }
        }
    }
    
    func sendmap() {
        self.addChildViewController(mapController)
        mapController.didMove(toParentViewController: self)
        
        self.view.addSubview(mapController.view)
        mapControllerAnchor = mapController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        mapControllerAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.view.bringSubview(toFront: container)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleLogout() {
        self.performSegue(withIdentifier: "loginView", sender: self)
    }

}

















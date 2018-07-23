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

protocol moveControllers {
    func moveTopProfile()
    func moveToMap()
}

class TabViewController: UIViewController, moveControllers {
    
    var swipe: Int = 1
    
    var pin: UILabel = {
        let label = UILabel()
        label.text = "▾"
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var container: UIView = {
        let containerBar = UIView()
        containerBar.translatesAutoresizingMaskIntoConstraints = false
        containerBar.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0
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
    
    lazy var walkthroughController: WalkthroughViewController = {
        let controller = WalkthroughViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Walkthrough"
        controller.view.alpha = 0
        controller.delegate = self
        return controller
    }()
    
    var mapControllerAnchor: NSLayoutConstraint!
    var accountControllerAnchor: NSLayoutConstraint!
    var mapCenterAnchor: NSLayoutConstraint!
    var profileCenterAnchor: NSLayoutConstraint!
    
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.statusBarStyle = .lightContent
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
        fetchUser()

    }
    
    func setupViews() {
        
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
        containerRightAnchor = container.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        containerRightAnchor.isActive = true
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
        
        self.view.addSubview(pin)
        pin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 6).isActive = true
        pin.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pin.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    @objc func moveToProfileTap(sender: UIButton) {
        moveTopProfile()
    }
    
    @objc func moveToProfileSwipe(sender: UITapGestureRecognizer) {
        moveTopProfile()
    }
    
    func moveTopProfile() {
        if mapControllerAnchor.constant == 0 {
            self.containerLeftAnchor.constant = 0
            self.containerRightAnchor.constant = -self.view.frame.width/3
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.statusBarStyle = .lightContent
                self.accountControllerAnchor.constant = 0
                self.mapControllerAnchor.constant = -self.view.frame.width
                self.mapCenterAnchor.constant = self.view.frame.width/4
                self.profileCenterAnchor.constant = self.view.frame.width/2
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
    }
    
    func moveToMap() {
        if accountControllerAnchor.constant == 0 {
            self.containerLeftAnchor.constant = self.view.frame.width/3
            self.containerRightAnchor.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.statusBarStyle = .default
                self.mapControllerAnchor.constant = 0
                self.accountControllerAnchor.constant = self.view.frame.width
                self.mapCenterAnchor.constant = self.view.frame.width/2
                self.profileCenterAnchor.constant = self.view.frame.width*3/4
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
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
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userVehicleID = dictionary["vehicleID"] as? String
                let userParkingID = dictionary["parkingID"] as? String
                
                if userVehicleID == nil && userParkingID == nil {
                    
                    self.view.addSubview(self.walkthroughController.view)
                    self.walkthroughController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                    self.walkthroughController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                    self.walkthroughController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    self.walkthroughController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.walkthroughController.view.alpha = 1
                    })
                    
                }
            }
        }, withCancel: nil)
        return
    }

}

















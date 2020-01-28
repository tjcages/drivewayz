//
//  PageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

var rightArrow: UIButton!
var leftArrow: UIButton!

let mapTutorialController = MapTutorialView()

protocol moveControllers {
    func dismissActiveController()
    
    func moveToProfile()
    func moveToMap()
    func lightContentStatusBar()
    func defaultContentStatusBar()
    func bringNewHostingController()
    func bringHostingController()
    func hideHamburger()
    func bringHamburger()
    func changeProfileImage(image: UIImage)
}

protocol controlsNewParking {
    func removeNewParkingView()
    func removeNewVehicleView()
    func moveTopProfile()
    func moveToMap()
}

protocol controlsAccountOptions {
    func openAccountView()
    func closeAccountView()
    
    func moveToMap()
    func bringUpcomingController()
    func bringHostingController()
    func bringNewHostingController()
    func bringSettingsController()
    func bringHelpController()
    func bringFeedbackController()
    func bringAnalyticsController()
}

protocol handleMapTutorial {
    func searchPressed()
    func recommendationPressed()
    func parkNowPressed()
    func reservePressed()
}

var tabDimmingView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Theme.DARK_GRAY
    view.alpha = 0
    
    return view
}()

class TabViewController: UIViewController, UNUserNotificationCenterDelegate, controlsAccountOptions, moveControllers {
    
    var swipe: Int = 1
    var delegate: handleStatusBarHide?
    
    enum emailConfirmation {
        case confirmed
        case unconfirmed
    }
    var emailConfirmed: emailConfirmation = .unconfirmed
    
    var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 16
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var mapController: MapKitViewController = {
        let controller = MapKitViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.accountDelegate = self
        controller.delegate = self
        
        return controller
    }()
    
    lazy var accountSlideController: AccountSlideViewController = {
        let controller = AccountSlideViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.moveDelegate = self
        
        return controller
    }()

    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var mapCenterAnchor: NSLayoutConstraint!
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!
    
    var statusBarShouldBeHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        NotificationCenter.default.addObserver(self, selector: #selector(monitorCurrentParking), name: NSNotification.Name(rawValue: "userBookingStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNewListing), name: NSNotification.Name(rawValue: "dismissNewListing"), object: nil)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.tabBar.isHidden = true
        
        setupViews()
        checkOpens()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DISAPPEARING")
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var mainTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(accountSlideController.view)
        accountSlideController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountSlideController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        accountSlideController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        accountSlideController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(mapController.view)
        mapCenterAnchor = mapController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            mapCenterAnchor.isActive = true
        mapController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(shadowView)
        self.view.bringSubviewToFront(mapController.view)
        shadowView.leftAnchor.constraint(equalTo: mapController.view.leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: mapController.view.rightAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: mapController.view.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: mapController.view.bottomAnchor).isActive = true
        
        self.view.addSubview(tabDimmingView)
        tabDimmingView.leftAnchor.constraint(equalTo: mapController.view.leftAnchor).isActive = true
        tabDimmingView.rightAnchor.constraint(equalTo: mapController.view.rightAnchor).isActive = true
        tabDimmingView.topAnchor.constraint(equalTo: mapController.view.topAnchor).isActive = true
        tabDimmingView.bottomAnchor.constraint(equalTo: mapController.view.bottomAnchor).isActive = true
        
        self.view.addSubview(blurView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToMapSwipe(sender:)))
        blurView.addGestureRecognizer(gesture)
        blurView.topAnchor.constraint(equalTo: mapController.view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: mapController.view.bottomAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: mapController.view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: mapController.view.rightAnchor).isActive = true
        
        createHamburgerButton()
        hamburgerButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        self.view.addSubview(hamburgerButton)
        hamburgerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        hamburgerButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        hamburgerButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        switch device {
        case .iphone8:
            hamburgerButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        case .iphoneX:
            hamburgerButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        }
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        delayWithSeconds(1) {
//            let controller = HostPortalController()
//            let navigation = UINavigationController(rootViewController: controller)
//            navigation.modalPresentationStyle = .overFullScreen
//            navigation.navigationBar.isHidden = true
//            self.present(navigation, animated: true, completion: nil)
//        }
    }
    
    func checkOpens() {
        var opens = UserDefaults.standard.integer(forKey: "numberOfOpens")
        if opens <= 1 {
            opens += 1
            UserDefaults.standard.set(opens, forKey: "numberOfOpens")
            UserDefaults.standard.synchronize()
            delayWithSeconds(1) {
                if BookedState == .none {
                    self.mapController.view.isUserInteractionEnabled = false
                    
                    self.mapController.view.isUserInteractionEnabled = true
                    mapTutorialController.delegate = self
                    mapTutorialController.modalPresentationStyle = .overFullScreen
                    mapTutorialController.modalTransitionStyle = .crossDissolve
                    
                    guard let position = self.view.superview?.convert(self.mapController.mainBarController.searchController.searchView.center, to: nil)
                        else { return }
                    
                    mapTutorialController.dimViewHeight = phoneHeight - mainBarNormalHeight + statusHeight
                    mapTutorialController.searchViewHeight = position.y - 3
                    //                mapTutorialController.searchViewHeight = mainBarNormalHeight + position.y + statusHeight
                    
                    self.present(mapTutorialController, animated: true, completion: {
                        //
                    })
                }
            }
        }
    }
    
    @objc func monitorCurrentParking() {
        if BookedState == .currentlyBooked {
            mapController.mainViewState = .currentBooking
        } else if BookedState == .reserved {
            mapController.mainViewState = .mainBar
        } else {
            mapController.mainViewState = .none
        }
    }
    
    func moveToProfile() {
        delegate?.hideStatusBar()
        mapCenterAnchor.constant = self.view.frame.width/2 + 60
        hamburgerWidthAnchor.constant = -24
        UIView.animate(withDuration: animationIn, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.shadowView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            tabDimmingView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.mapController.view.layer.cornerRadius = 16
            tabDimmingView.layer.cornerRadius = 16
            tabDimmingView.alpha = 0.2
            hamburgerButton.alpha = 0
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func moveToMap() {
        delegate?.bringStatusBar()
        mapCenterAnchor.constant = 0
        bringHamburger()
        hamburgerWidthAnchor.constant = -28
        UIView.animate(withDuration: animationOut, animations: {
            self.mapController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.shadowView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            tabDimmingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.mapController.view.layer.cornerRadius = 0
            tabDimmingView.layer.cornerRadius = 0
            tabDimmingView.alpha = 0
            hamburgerButton.alpha = 1
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func openAccountView() {
        openProfileOptions()
        UIView.animate(withDuration: 0.1, animations: {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func closeAccountView() {
        closeProfileOptions()
        delegate?.hideStatusBar()
        delayWithSeconds(animationIn) {
            UIView.animate(withDuration: animationIn, animations: {
                self.gradientContainer.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.defaultStatusBar()
            }
        }
    }
    
    @objc func dismissNewListing() {
        dismiss(animated: true) {
            self.bringHostingController()
        }
    }
    
    @objc func profileButtonPressed() {
        view.endEditing(true)
        hideHamburger()
        moveToProfile()
    }
    
    @objc func moveToMapTap(sender: UIButton) {
        moveToMap()
        self.accountSlideController.forceSelectBook() 
    }
    
    @objc func moveToMapSwipe(sender: UITapGestureRecognizer) {
        moveToMap()
        self.accountSlideController.forceSelectBook()
    }
    
    func openProfileOptions() {
        self.mapCenterAnchor.constant = phoneWidth * 1.3
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeProfileOptions() {
        self.mapCenterAnchor.constant = self.view.frame.width/2 + 60
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissActiveController() {
        self.closeAccountView()
        self.moveToProfile()
    }
    
    func changeProfileImage(image: UIImage) {
        self.accountSlideController.profileImageView.image = image
    }
    
}


////// Bring Controllers
extension TabViewController {
    
    func bringUpcomingController() {
        let controller = UserUpcomingViewController()
        controller.delegate = self
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(controller, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringHostingController() {
        let controller = HostPortalController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringNewHostingController() {
        let controller = HostOnboardingController()
        controller.delegate = self
//        controller.moveDelegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.presentationController?.delegate = controller
//        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringSettingsController() {
        let controller = UserSettingsViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringHelpController() {
        let controller = TESTHelpViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                self.lightContentStatusBar()
                self.delegate?.bringStatusBar()
            }
        }
    }
    
    func bringFeedbackController() {
        let controller = UserContactViewController()
        controller.delegate = self
        controller.context = "Feedback"
        controller.mainLabel.text = "Give feedback"
        controller.informationLabel.text = "Please reach out to us if you have any suggestions, questions, or concerns"
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func bringAnalyticsController() {
        let controller = AnalyticsViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        navigation.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func hideHamburger() {
        UIView.animate(withDuration: animationIn) {
            hamburgerButton.alpha = 0
        }
    }
    
    func bringHamburger() {
        UIView.animate(withDuration: animationIn) {
            hamburgerButton.alpha = 1
        }
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    func defaultContentStatusBar() {
        self.delegate?.defaultStatusBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension TabViewController: handleMapTutorial {
    
    func searchPressed() {
        mapController.openSearch()
    }
    
    func recommendationPressed() {
        mapController.recommendButtonPressed()
    }
    
    func parkNowPressed() {
        mapController.mainBarController.searchController.durationBottomController.parkNowButton.sendActions(for: .touchUpInside)
    }
    
    func reservePressed() {
        mapController.mainBarController.searchController.durationBottomController.reserveSpotButton.sendActions(for: .touchUpInside)
    }
    
}






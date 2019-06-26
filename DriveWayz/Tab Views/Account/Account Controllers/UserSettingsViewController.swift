//
//  SettingsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import Stripe
import Cosmos

protocol changeSettingsHandler {
    func changeEmail(text: String)
    func changePhone(text: String)
    func changeName(text: String)
    
    func bringBackMain()
    func moveToNext()
    func moveToAbout()
    func editSettings(title: String, subtitle: String)
    func handleLogout()
    
    func moveToTerms()
    func moveToPrivacy()
}

var userInformationNumbers: String = ""
var userInformationImage: UIImage = UIImage()

class UserSettingsViewController: UIViewController, changeSettingsHandler {
    
    var delegate: moveControllers?
    var paymentInformation: String = ""
    var pickerParking: UIImagePickerController?
    
    var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 4
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 20
        view.settings.starMargin = 0
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.65"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background4")
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var accountController: AccountSettingsViewController = {
        let controller = AccountSettingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var otherController: OtherSettingsViewController = {
        let controller = OtherSettingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var editSettingsController: EditSettingsViewController = {
        let controller = EditSettingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var aboutController: AboutUsViewController = {
        let controller = AboutUsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var termsController: DrivewayzTermsViewController = {
        let controller = DrivewayzTermsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var privacyController: DrivewayzPrivacyViewController = {
        let controller = DrivewayzPrivacyViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ver. 3.145"
        label.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.5)
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true

        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
        setupAccount()
        setupControllers()
        observeUserInformation()
        getVersionNumber()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var editAnchor: NSLayoutConstraint!
    var aboutAnchor: NSLayoutConstraint!
    var termsAnchor: NSLayoutConstraint!
    var privacyAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 975)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
                gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
    }
    
    func setupAccount() {
        
        self.view.addSubview(profileImageView)
        profileImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileImageView.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(editProfile))
        profileImageView.addGestureRecognizer(tap)
        
        self.view.addSubview(stars)
        stars.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -16).isActive = true
        stars.rightAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 8).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(starLabel)
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.rightAnchor.constraint(equalTo: stars.leftAnchor, constant: -2).isActive = true
        starLabel.sizeToFit()
        
        scrollView.addSubview(accountController.view)
        accountController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 48).isActive = true
        accountController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        accountController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        accountController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        scrollView.addSubview(otherController.view)
        otherController.view.topAnchor.constraint(equalTo: accountController.view.bottomAnchor, constant: 20).isActive = true
        otherController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        otherController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        otherController.view.heightAnchor.constraint(equalToConstant: 540).isActive = true

        scrollView.addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: otherController.view.bottomAnchor, constant: 16).isActive = true
        versionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        versionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupControllers() {
        
        self.view.addSubview(editSettingsController.view)
        editSettingsController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        editSettingsController.view.bottomAnchor.constraint(equalTo: accountController.view.bottomAnchor).isActive = true
        editSettingsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        editAnchor = editSettingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            editAnchor.isActive = true
        
        self.view.addSubview(aboutController.view)
        aboutController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        aboutController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        aboutController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        aboutAnchor = aboutController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            aboutAnchor.isActive = true
        
        self.view.addSubview(termsController.view)
        termsController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        termsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        termsAnchor = termsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            termsAnchor.isActive = true
        
        self.view.addSubview(privacyController.view)
        self.view.bringSubviewToFront(gradientContainer)
        self.view.bringSubviewToFront(mainLabel)
        self.view.bringSubviewToFront(profileImageView)
        
        privacyController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        privacyController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        privacyController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        privacyAnchor = privacyController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            privacyAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
    }
    
    func editSettings(title: String, subtitle: String) {
        self.moveToNext()
        self.scrollMinimized()
        self.editSettingsController.setData(title: title, subtitle: subtitle)
        self.editAnchor.constant = 0
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.accountController.view.alpha = 0
            self.otherController.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Edit Account"
            }, completion: nil)
        }
    }
    
    func observeUserInformation() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    self.accountController.optionsSub = []
                    self.otherController.optionsSub = []
                    if let name = dictionary["name"] as? String {
                        self.accountController.optionsSub.append(name)
                    }
                    if let userPicture = dictionary["picture"] as? String {
                        if userPicture == "" {
                            self.profileImageView.image = UIImage(named: "background4")
                        } else {
                            self.profileImageView.loadImageUsingCacheWithUrlString(userPicture)
                        }
                    }
                    if let userRating = dictionary["rating"] as? Double {
                        self.starLabel.text = String(format:"%.01f", userRating)
                    } else {
                        self.starLabel.text = "5.0"
                    }
                    if let email = dictionary["email"] as? String {
                        self.accountController.optionsSub.append(email)
                    } else { self.accountController.optionsSub.append("No email") }
                    if let phone = dictionary["phone"] as? String {
                        self.accountController.optionsSub.append(phone)
                    } else { self.accountController.optionsSub.append("No phone number") }
                    self.otherController.optionsSub.append("Payment")
                    self.otherController.optionsTableView.reloadData()
                    if let vehicle = dictionary["selectedVehicle"] as? String {
                        let vehicleRef = Database.database().reference().child("UserVehicles").child(vehicle)
                        vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:Any] {
                                if let vehicleLicensePlate = dictionary["licensePlate"] as? String {
                                    self.otherController.optionsSub.append(vehicleLicensePlate)
                                } else {
                                    self.otherController.optionsSub.append("No vehicle")
                                }
                                self.accountController.optionsTableView.reloadData()
                                self.otherController.optionsTableView.reloadData()
                            }
                        })
                    } else {
                        self.otherController.optionsSub.append("No vehicle")
                    }
                }
            }
        }
    }

    @objc func backButtonPressed() {
        self.view.endEditing(true)
        if self.termsAnchor.constant == 0 || self.privacyAnchor.constant == 0 {
            self.bringBackAbout()
        } else {
            self.bringBackMain()
        }
    }
    
    @objc func bringBackAbout() {
        self.termsAnchor.constant = phoneWidth
        self.privacyAnchor.constant = phoneWidth
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.aboutController.view.alpha = 1
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "About Us"
            }, completion: nil)
        }
    }
    
    @objc func bringBackMain() {
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.mainLabel.text = ""
            self.accountController.view.alpha = 1
            self.otherController.view.alpha = 1
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.editAnchor.constant = self.view.frame.width
            self.aboutAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.accountController.view.alpha = 1
            self.otherController.view.alpha = 1
            self.profileImageView.alpha = 1
            self.backgroundCircle.alpha = 1
            self.stars.alpha = 1
            self.starLabel.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
            self.delegate?.bringExitButton()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Settings"
            }, completion: nil)
        }
    }
    
    func hideExitButton() {
        self.delegate?.hideExitButton()
    }
    
    func moveToNext() {
        UIView.animate(withDuration: animationIn) {
            self.delegate?.hideExitButton()
            self.backButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func moveToAbout() {
        self.moveToNext()
        self.aboutAnchor.constant = 0
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.accountController.view.alpha = 0
            self.otherController.view.alpha = 0
            self.mainLabel.text = ""
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.lightContentStatusBar()
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "About Us"
            }, completion: nil)
        }
    }
    
    func moveToTerms() {
        self.termsAnchor.constant = 0
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.aboutController.view.alpha = 0
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Terms & Conditions"
            }, completion: nil)
        }
    }
    
    func moveToPrivacy() {
        self.privacyAnchor.constant = 0
        UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.aboutController.view.alpha = 0
            self.mainLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.mainLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainLabel.text = "Privacy Policy"
            }, completion: nil)
        }
    }
    
    var startupAnchor: NSLayoutConstraint!
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginManager = LoginManager()
            loginManager.logOut()
        } catch let logoutError {
            print(logoutError)
        }
        self.delegate?.hideExitButton()
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()

        let launchController = LaunchAnimationsViewController()
        launchController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(launchController.view)
        self.addChild(launchController)
        launchController.willMove(toParent: self)
        launchController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startupAnchor = launchController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            self.startupAnchor.isActive = true
        launchController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        launchController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        UIView.animate(withDuration: animationOut) {
            self.startupAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}


extension UserSettingsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            if self.profileImageView.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.gradientContainer.layer.shadowOpacity = 0
                    self.profileImageView.alpha = 1
                    self.backgroundCircle.alpha = 1
                    self.stars.alpha = 1
                    self.starLabel.alpha = 1
                }
            }
            if self.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                self.scrollExpanded()
            }
        } else if translation >= 40 && self.profileImageView.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.gradientContainer.layer.shadowOpacity = 0.2
                self.profileImageView.alpha = 0
                self.backgroundCircle.alpha = 0
                self.stars.alpha = 0
                self.starLabel.alpha = 0
            }
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                self.scrollMinimized()
            }
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.delegate?.defaultContentStatusBar()
        self.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: animationIn) {
            self.profileImageView.alpha = 1
            self.backgroundCircle.alpha = 1
            self.stars.alpha = 1
            self.starLabel.alpha = 1
            self.gradientContainer.backgroundColor = UIColor.clear
            self.backButton.tintColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.DARK_GRAY
        }
    }
    
    func scrollMinimized() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.profileImageView.alpha = 0
            self.backgroundCircle.alpha = 0
            self.stars.alpha = 0
            self.starLabel.alpha = 0
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.backButton.tintColor = Theme.WHITE
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
}


extension UserSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func editProfile() {
        let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload a new profile picture?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: { action in
            self.handleSelectParkingImageView()
        }))
        alert.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertAction.Style.default, handler: { action in
            self.handleTakeAnImageView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleSelectParkingImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        
        if let presentor = pickerParking {
            present(presentor, animated: true, completion: nil)
        }
    }
    
    @objc func handleTakeAnImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        pickerParking?.sourceType = .camera
        
        if let presentor = pickerParking {
            present(presentor, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            if picker == pickerParking {
                self.profileImageView.image = selectedImage
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let storageRef = Storage.storage().reference().child("UserProfileImages").child(userID)
                let ref = Database.database().reference().child("users").child(userID)
                if let uploadData = selectedImage.jpegData(compressionQuality: 0.5) {
                    storageRef.child("profilePicture").putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil { print(error ?? ""); return }
                        storageRef.child("profilePicture").downloadURL(completion: { (url, error) in
                            if let profileURL = url?.absoluteString {
                                ref.updateChildValues(["picture": profileURL] as [String: Any])
                                self.delegate?.changeProfileImage(image: selectedImage)
                            }
                        })
                    }
                }
            }
        }
        dismiss(animated: true) {
            self.view.layoutIfNeeded()
            self.delegate?.defaultContentStatusBar()
            self.backButton.tintColor = Theme.DARK_GRAY
        }
    }
    
    func changeEmail(text: String) {
        self.accountController.optionsSub.insert(text, at: 1)
        self.accountController.optionsSub.remove(at: 2)
        self.accountController.optionsTableView.reloadData()
        self.otherController.optionsTableView.reloadData()
    }
    
    func changePhone(text: String) {
        self.accountController.optionsSub.insert(text, at: 2)
        self.accountController.optionsSub.remove(at: 3)
        self.accountController.optionsTableView.reloadData()
        self.otherController.optionsTableView.reloadData()
    }
    
    func changeName(text: String) {
        self.accountController.optionsSub.insert(text, at: 0)
        self.accountController.optionsSub.remove(at: 1)
        self.accountController.optionsTableView.reloadData()
        self.otherController.optionsTableView.reloadData()
    }
    
    func getVersionNumber() {
        //First get the nsObject by defining as an optional anyObject
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Ver. " + version
        }
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

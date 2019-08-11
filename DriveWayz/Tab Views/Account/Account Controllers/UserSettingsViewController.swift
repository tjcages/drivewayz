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
    
    func moveToAbout()
    func editSettings(title: String, subtitle: String)
    func handleLogout()
}

var userInformationNumbers: String = ""
var userInformationImage: UIImage = UIImage()

class UserSettingsViewController: UIViewController, changeSettingsHandler {
    
    var delegate: moveControllers?
    var paymentInformation: String = ""
    var pickerParking: UIImagePickerController?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.totalStars = 1
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.settings.filledImage = UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Star Empty")?.withRenderingMode(.alwaysOriginal)
        view.text = "5.0"
        view.semanticContentAttribute = .forceRightToLeft
        view.settings.textColor = Theme.WHITE
        view.settings.textFont = Fonts.SSPSemiBoldH6
        
        return view
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
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
    
    var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ver. 3.145"
        label.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.5)
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        
        return label
    }()

    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true

        scrollView.delegate = self
        
        setupViews()
        setupAccount()
        observeUserInformation()
        getVersionNumber()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 975)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
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
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func setupAccount() {
        
        gradientContainer.addSubview(profileImageView)
        profileImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileImageView.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(editProfile))
        profileImageView.addGestureRecognizer(tap)
        
        gradientContainer.addSubview(stars)
        stars.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 4).isActive = true
        stars.rightAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 4).isActive = true
        stars.sizeToFit()
        
        scrollView.addSubview(accountController.view)
        accountController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        accountController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        accountController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        accountController.view.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        scrollView.addSubview(otherController.view)
        otherController.view.topAnchor.constraint(equalTo: accountController.view.bottomAnchor, constant: 16).isActive = true
        otherController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        otherController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        otherController.view.heightAnchor.constraint(equalToConstant: 480).isActive = true

        scrollView.addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: otherController.view.bottomAnchor, constant: 16).isActive = true
        versionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        versionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func editSettings(title: String, subtitle: String) {
        let controller = EditSettingsViewController()
        controller.delegate = self
        controller.setData(title: title, subtitle: subtitle)
        controller.gradientHeightAnchor = self.gradientHeightAnchor.constant
        controller.mainLabel.transform = self.mainLabel.transform
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func observeUserInformation() {
        self.loadingLine.startAnimating()
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
                            self.profileImageView.loadImageUsingCacheWithUrlString(userPicture) { (bool) in
                                self.loadingLine.endAnimating()
                                if !bool {
                                    self.profileImageView.image = UIImage(named: "background4")
                                }
                            }
                        }
                    }
                    if let userRating = dictionary["rating"] as? Double {
                        self.stars.text = String(format:"%.01f", userRating)
                    } else {
                        self.stars.text = "5.0"
                    }
                    if let email = dictionary["email"] as? String {
                        self.accountController.optionsSub.append(email)
                    } else { self.accountController.optionsSub.append("No email") }
                    if let phone = dictionary["phone"] as? String {
                        self.accountController.optionsSub.append(phone)
                    } else { self.accountController.optionsSub.append("No phone number") }
                    self.otherController.optionsSub.append("Payment")
                    self.accountController.optionsTableView.reloadData()
                    self.otherController.optionsTableView.reloadData()
                    if let vehicle = dictionary["selectedVehicle"] as? String {
                        let vehicleRef = Database.database().reference().child("UserVehicles").child(vehicle)
                        vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:Any] {
                                self.loadingLine.endAnimating()
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
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            self.backButton.alpha = 0
        }
    }
    
    func moveToAbout() {
        let controller = AboutUsViewController()
        controller.delegate = self
        controller.gradientHeightAnchor = self.gradientHeightAnchor.constant
        controller.mainLabel.transform = self.mainLabel.transform
        self.navigationController?.pushViewController(controller, animated: true)
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
        self.delegate?.dismissActiveController()
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
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if translation > 20 {
                    if self.profileImageView.alpha == 1 {
                        UIView.animate(withDuration: animationIn) {
                            self.profileImageView.alpha = 0
                            self.backgroundCircle.alpha = 0
                            self.stars.alpha = 0
                        }
                    }
                } else {
                    if self.profileImageView.alpha == 0 {
                        UIView.animate(withDuration: animationIn) {
                            self.profileImageView.alpha = 1
                            self.backgroundCircle.alpha = 1
                            self.stars.alpha = 1
                        }
                    }
                }
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.profileImageView.alpha = 1
            self.backgroundCircle.alpha = 1
            self.stars.alpha = 1
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.profileImageView.alpha = 0
            self.backgroundCircle.alpha = 0
            self.stars.alpha = 0
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
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
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let build = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Ver. " + version + "." + build
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

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

protocol changeSettingsHandler {
    func changeEmail(text: String)
    func changePhone(text: String)
    func bringBackMain()
}

var userInformationNumbers: String = ""
var userInformationImage: UIImage = UIImage()

class UserSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, changeSettingsHandler {
    
    var delegate: moveControllers?
    var paymentInformation: String = ""
    var pickerParking: UIImagePickerController?
    
    var options: [String] = ["Email", "Phone", "Payment", "Vehicle", "", "Notifications", "Accessibility", "Terms", "", "Logout"]
    var optionsSub: [String] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    var optionsImages: [UIImage] = [UIImage(named: "email")!, UIImage(named: "phone")!, UIImage(named: "credit_card")!, UIImage(named: "car")!, UIImage(), UIImage(named: "bell_notification")!,UIImage(named: "tool")!, UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background2")
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textColor = Theme.BLACK
        profileName.font = Fonts.SSPRegularH3
        profileName.text = ""
        
        return profileName
    }()
    
    var editImage: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit photo", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH5
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        return button
    }()
    
    var profileLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var editSettingsController: EditSettingsViewController = {
        let controller = EditSettingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var termsController: DrivewayzTermsViewController = {
        let controller = DrivewayzTermsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true

        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(bringBackMain))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
        observeUserInformation()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var editAnchor: NSLayoutConstraint!
    var termsAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 760)
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            containerCenterAnchor.isActive = true
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
        
        scrollView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        scrollView.addSubview(profileName)
        profileName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        profileName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2).isActive = true
        profileName.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(editImage)
        editImage.leftAnchor.constraint(equalTo: profileName.leftAnchor).isActive = true
        editImage.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -2).isActive = true
        editImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        if let width = editImage.titleLabel?.text?.width(withConstrainedHeight: 40, font: (editImage.titleLabel?.font)!) {
            editImage.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        scrollView.addSubview(profileLine)
        profileLine.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        profileLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profileLine.topAnchor.constraint(equalTo: editImage.bottomAnchor, constant: 20).isActive = true
        profileLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: profileLine.bottomAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
            optionsHeight.isActive = true
        
        self.view.addSubview(editSettingsController.view)
        editSettingsController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        editSettingsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        editSettingsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        editAnchor = editSettingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            editAnchor.isActive = true
        
        self.view.addSubview(termsController.view)
        self.view.bringSubviewToFront(gradientContainer)
        termsController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        termsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        termsAnchor = termsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            termsAnchor.isActive = true
        
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
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
    }
    
    func observeUserInformation() {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    self.optionsSub = []
                    if let name = dictionary["name"] as? String {
                        self.profileName.text = name
                    }
                    if let userPicture = dictionary["picture"] as? String {
                        if userPicture == "" {
                            self.profileImageView.image = UIImage(named: "background4")
                        } else {
                            self.profileImageView.loadImageUsingCacheWithUrlString(userPicture)
                        }
                    }
                    if let email = dictionary["email"] as? String {
                        self.optionsSub.append(email)
                    } else { self.optionsSub.append("No email") }
                    if let phone = dictionary["phone"] as? String {
                        self.optionsSub.append(phone)
                    } else { self.optionsSub.append("No phone number") }
                    self.optionsSub.append("Payment")
                    self.optionsTableView.reloadData()
                    if let vehicle = dictionary["selectedVehicle"] as? String {
                        let vehicleRef = Database.database().reference().child("UserVehicles").child(vehicle)
                        vehicleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:Any] {
                                if let vehicleLicensePlate = dictionary["licensePlate"] as? String {
                                    self.optionsSub.append(vehicleLicensePlate)
                                } else {
                                    self.optionsSub.append("No vehicle")
                                }
                                self.optionsTableView.reloadData()
                            }
                        })
                    } else {
                        self.optionsSub.append("No vehicle")
                    }
                }
            }
        }
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        self.bringBackMain()
    }
    
    @objc func bringBackMain() {
        UIView.animate(withDuration: animationOut, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.containerCenterAnchor.constant = 0
            self.editAnchor.constant = self.view.frame.width
            self.termsAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(60 * (self.options.count) - 60)
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if options.count > indexPath.row {
            if options[indexPath.row] == "" {
                return 30
            } else {
                return 60
            }
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        if options.count > indexPath.row {
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            if indexPath.row < self.optionsSub.count {
                cell.titleLabel.text = options[indexPath.row]
                cell.subtitleLabel.text = optionsSub[indexPath.row]
                cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
                cell.paymentButton.alpha = 0
                cell.titleLabel.alpha = 1
            } else {
                cell.titleLabel.text = options[indexPath.row]
                let index = indexPath.row - self.optionsSub.count
                if index == 0 {
                    cell.titleLabel.alpha = 1
                    cell.subtitleLabel.text = ""
                    cell.iconView.setImage(UIImage(), for: .normal)
                } else if index == 1 {
                    cell.titleLabel.alpha = 0.4
                    cell.subtitleLabel.text = "Update your preferences"
                    cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
                } else if index == 2 {
                    cell.titleLabel.alpha = 0.4
                    cell.subtitleLabel.text = "Wheelchair access"
                    cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
                } else if index == 3 {
                    cell.titleLabel.alpha = 1
                    cell.subtitleLabel.text = ""
                    cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
                } else if index == 4 {
                    cell.titleLabel.alpha = 1
                    cell.subtitleLabel.text = ""
                    cell.iconView.setImage(UIImage(), for: .normal)
                } else if index == 5 {
                    cell.titleLabel.alpha = 1
                    cell.subtitleLabel.text = ""
                    cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
                }
            }
            if cell.titleLabel.text == "Payment" || cell.titleLabel.text == "Vehicle" || cell.titleLabel.text == "Notifications" || cell.titleLabel.text == "Accessibility" || cell.titleLabel.text == "Logout" || cell.titleLabel.text == "" {
                cell.nextButton.alpha = 0
            } else {
                cell.nextButton.alpha = 1
            }
            if options[indexPath.row] == "" {
                cell.nextButton.alpha = 0
                cell.backgroundColor = Theme.OFF_WHITE
            }
            if cell.titleLabel.text == "Logout" {
                cell.titleLabel.textColor = Theme.HARMONY_RED
                cell.nextButton.alpha = 0
            } else if cell.titleLabel.text == "Vehicle" || cell.titleLabel.text == "Terms" || cell.titleLabel.text == "" {
                cell.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: self.view.frame.width)
            } else {
                cell.titleLabel.textColor = Theme.BLACK
            }
            if cell.subtitleLabel.text == "" {
                cell.titleTopAnchor.isActive = false
                cell.titleCenterAnchor.isActive = true
                cell.titleLeftAnchor.constant = -20
            } else {
                cell.titleTopAnchor.isActive = true
                cell.titleCenterAnchor.isActive = false
                cell.titleLeftAnchor.constant = 30
            }
            if cell.subtitleLabel.text == "Payment" {
                cell.paymentButton.alpha = 1
                cell.subtitleLabel.text = ""
                cell.paymentButton.setTitle(userInformationNumbers, for: .normal)
                cell.paymentButton.setImage(userInformationImage, for: .normal)
            } else {
                cell.paymentButton.alpha = 0
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        cell.titleLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        cell.titleLabel.textColor = Theme.BLACK
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! SettingsCell
        if let title = cell.titleLabel.text, let subtitle = cell.subtitleLabel.text {
            if title == "Terms" {
                self.termsAnchor.constant = 0
            } else if title == "Logout" {
                self.handleLogout()
            } else if title != "" && title != "Notifications" && title != "Accessibility" && title != "Vehicle" && title != "Payment" {
                if subtitle == "No phone number" || subtitle == "No email" {
                    self.editSettingsController.setData(title: title, subtitle: "")
                } else {
                    self.editSettingsController.setData(title: title, subtitle: subtitle)
                }
                self.editAnchor.constant = 0
            }
            if title == "Email" || title == "Phone" || title == "Terms" {
                self.moveToNext()
            }
        }
    }
    
    func moveToNext() {
        UIView.animate(withDuration: animationIn) {
            self.delegate?.hideExitButton()
            self.backButton.alpha = 1
            self.containerCenterAnchor.constant = -self.view.frame.width/2
            self.view.layoutIfNeeded()
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
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
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
        self.optionsSub.insert(text, at: 0)
        self.optionsSub.remove(at: 1)
        self.optionsTableView.reloadData()
    }
    
    func changePhone(text: String) {
        self.optionsSub.insert(text, at: 1)
        self.optionsSub.remove(at: 2)
        self.optionsTableView.reloadData()
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

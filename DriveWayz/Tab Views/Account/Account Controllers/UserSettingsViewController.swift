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

class UserSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: moveControllers?
    
    var options: [String] = ["Email", "Phone", "Payment", "Vehicle", "", "Notifications", "Accessibility", "Terms", "", "Logout"]
    var optionsSub: [String] = ["tyler.cagle@colorado.edu", "+1 (303) 564-4120", "Visa 4424", "000-XXX", "", "Update your preferences", "Wheelchair access", "", "", ""]
    var optionsImages: [UIImage] = [UIImage(named: "email")!, UIImage(named: "phone")!, UIImage(named: "credit_card")!, UIImage(named: "car")!, UIImage(), UIImage(named: "bell_notification")!,UIImage(named: "tool")!, UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
//        view.clipsToBounds = true
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
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
        profileName.text = "Name"
        
        return profileName
    }()
    
    var editImage: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit photo", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH5
        
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
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var vehicleController: UserVehicleViewController = {
        let controller = UserVehicleViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Vehicle"
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

        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(bringBackMain))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var editAnchor: NSLayoutConstraint!
    var termsAnchor: NSLayoutConstraint!
    var vehicleAnchor: NSLayoutConstraint!

    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160)
            containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 760)
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            containerCenterAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
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
        profileLine.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        profileLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profileLine.topAnchor.constraint(equalTo: editImage.bottomAnchor, constant: 20).isActive = true
        profileLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: profileLine.bottomAnchor).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
            optionsHeight.isActive = true
        
        self.view.addSubview(editSettingsController.view)
        editSettingsController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        editSettingsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        editSettingsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        editAnchor = editSettingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            editAnchor.isActive = true
        
        self.view.addSubview(termsController.view)
        termsController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        termsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        termsAnchor = termsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            termsAnchor.isActive = true
        
        self.view.addSubview(vehicleController.view)
        vehicleController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        vehicleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        vehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        vehicleAnchor = vehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            vehicleAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 38).isActive = true
        }
        
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        self.bringBackMain()
    }
    
    @objc func bringBackMain() {
        UIView.animate(withDuration: animationOut, animations: {
            self.delegate?.changeMainLabel(text: "Settings")
            self.delegate?.moveMainLabel(percent: 0)
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.containerHeightAnchor.constant = 160
            self.containerCenterAnchor.constant = 0
            self.editAnchor.constant = self.view.frame.width
            self.termsAnchor.constant = self.view.frame.width
            self.vehicleAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(60 * self.options.count - 60)
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if options[indexPath.row] == "" {
            return 30
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.titleLabel.text = options[indexPath.row]
        if options[indexPath.row] == "" {
            cell.nextButton.alpha = 0
            cell.backgroundColor = Theme.OFF_WHITE
        }
        if cell.titleLabel.text == "Logout" {
            cell.titleLabel.textColor = Theme.HARMONY_RED
            cell.nextButton.alpha = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        } else if cell.titleLabel.text == "Vehicle" || cell.titleLabel.text == "Terms" || cell.titleLabel.text == "" {
            cell.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: self.view.frame.width)
        } else {
            cell.titleLabel.textColor = Theme.BLACK
            cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
        if optionsSub[indexPath.row] == "" {
            cell.titleTopAnchor.isActive = false
            cell.titleCenterAnchor.isActive = true
            cell.titleLeftAnchor.constant = -20
        } else {
            cell.titleTopAnchor.isActive = true
            cell.titleCenterAnchor.isActive = false
            cell.titleLeftAnchor.constant = 30
        }
        cell.subtitleLabel.text = optionsSub[indexPath.row]
        cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
        cell.selectionStyle = .none
        
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
                self.delegate?.changeMainLabel(text: title)
                self.termsAnchor.constant = 0
            } else if title == "Logout" {
                self.handleLogout()
            } else if title == "Vehicle" {
                self.vehicleAnchor.constant = 0
                switch device {
                case .iphone8:
                    self.vehicleController.containerHeightAnchor.constant = 80
                case .iphoneX:
                    self.vehicleController.containerHeightAnchor.constant = 90
                }
            } else if title != "" {
                self.editSettingsController.setData(title: title, subtitle: subtitle)
                self.editAnchor.constant = 0
            }
            self.moveToNext()
        }
    }
    
    func moveToNext() {
        UIView.animate(withDuration: animationIn) {
            self.delegate?.moveMainLabel(percent: 1)
            self.delegate?.hideExitButton()
            self.backButton.alpha = 1
            switch device {
            case .iphone8:
                self.containerHeightAnchor.constant = 80
            case .iphoneX:
                self.containerHeightAnchor.constant = 90
            }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= 50 && translation >= 10 {
            let percent = (translation-10)/40
            switch device {
            case .iphone8:
                self.containerHeightAnchor.constant = 160 - (percent * 80)
            case .iphoneX:
                self.containerHeightAnchor.constant = 160 - (percent * 90)
            }
            self.delegate?.moveMainLabel(percent: percent)
        } else if translation < 10 {
            self.containerHeightAnchor.constant = 160
            self.delegate?.moveMainLabel(percent: 0)
        } else {
            self.delegate?.moveMainLabel(percent: 1)
            switch device {
            case .iphone8:
                self.containerHeightAnchor.constant = 80
            case .iphoneX:
                self.containerHeightAnchor.constant = 90
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation < 30 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 0
            }
        } else if translation >= 30 && translation <= 50 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 50
            }
        }
    }


}

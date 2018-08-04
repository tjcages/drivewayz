//
//  AccountViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase
import Floaty
import FacebookLogin

var database: Database!
var storage: Storage!
var lattitudeConstant: Double = 0
var longitudeConstant: Double = 0
var formattedAddress: String = ""
var cityAddress: String = ""
var parkingSpotImage: UIImage?
var parking: Int = 0

protocol controlsBankAccount {
    func setupBankAccount()
    func removeBankAccountView()
}

protocol sendNewParking {
    func setupAddAVehicle()
    func setupAddAParkingSpot()
}

protocol controlsAccountViews {
    func removeOptionsFromView()
    func changeCurrentView(height: CGFloat)
}

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, controlsBankAccount, controlsAccountViews, sendNewParking {

    var parkingImage: ParkingImage = ParkingImage.noImage
    var parkingStatus: ParkingStatus = ParkingStatus.noParking
    var vehicleStatus: VehicleStatus = VehicleStatus.noVehicle
    
    var delegate: controlsNewParking?

    var visualBlurEffect = UIVisualEffectView()
    var picker = UIImagePickerController()
    
    var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var profileView: UIView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var parkingView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var vehicleView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var currentController: CurrentViewController = {
        let controller = CurrentViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Current"
        controller.delegate = self
        return controller
    }()
    
    lazy var recentController: UserRecentViewController = {
        let controller = UserRecentViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Recent"
        return controller
    }()
    
    lazy var bankController: BankAccountViewController = {
        let controller = BankAccountViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Charts"
        controller.delegate = self
        return controller
    }()
    
    lazy var parkingController: UserParkingViewController = {
        let controller = UserParkingViewController()
        controller.viewDelegate = self
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.bankDelegate = self
        controller.title = "Parking"
        return controller
    }()
    
    lazy var vehicleController: UserVehicleViewController = {
        let controller = UserVehicleViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.title = "Vehicle"
        return controller
    }()
    
    var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        let image = UIImage(named: "background4")
        profileImageView.image = image
        profileImageView.isUserInteractionEnabled = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = UIColor.white
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        return profileImageView
    }()
    
    var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textColor = UIColor.white
        profileName.layer.shadowColor = UIColor.darkGray.cgColor
        profileName.layer.shadowRadius = 1
        profileName.layer.shadowOpacity = 0.8
        profileName.layer.shadowOffset = CGSize(width: 1, height: 1)
        profileName.layer.masksToBounds = false
        profileName.clipsToBounds = false
        profileName.contentMode = .topLeft
        profileName.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        
        return profileName
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Add")
        button.setImage(image, for: .normal)
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    lazy var profileWrap: UIView = {
        let grayView = UIView()
        
        let background = CAGradientLayer().blueColor()
        switch device {
        case .iphone8:
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
        case .iphoneX:
             background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        }
        background.zPosition = -10
        grayView.layer.insertSublayer(background, at: 0)
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.isUserInteractionEnabled = true
        grayView.alpha = 0.9
        
        return grayView
    }()
  
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var overlay: UIView = {
        let overlay = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        overlay.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        overlay.layer.borderWidth = 2
        overlay.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5)
        
        return overlay
    }()
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = Theme.OFF_WHITE
        
        return segmentControlView
    }()
    
    var profileSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Profile", for: .normal)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        info.setTitleColor(Theme.DARK_GRAY, for: .normal)
        info.titleLabel?.textAlignment = .center
        info.addTarget(self, action: #selector(recentPressed(sender:)), for: .touchUpInside)
        
        return info
    }()
    
    var parkingSegment: UIButton = {
        let availability = UIButton()
        availability.translatesAutoresizingMaskIntoConstraints = false
        availability.backgroundColor = UIColor.clear
        availability.setTitle("Hosting", for: .normal)
        availability.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        availability.setTitleColor(Theme.DARK_GRAY, for: .normal)
        availability.titleLabel?.textAlignment = .center
        availability.addTarget(self, action: #selector(parkingPressed(sender:)), for: .touchUpInside)
        
        return availability
    }()
    
    var vehicleSegment: UIButton = {
        let reviews = UIButton()
        reviews.translatesAutoresizingMaskIntoConstraints = false
        reviews.backgroundColor = UIColor.clear
        reviews.setTitle("Vehicle", for: .normal)
        reviews.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        reviews.setTitleColor(Theme.DARK_GRAY, for: .normal)
        reviews.titleLabel?.textAlignment = .center
        reviews.addTarget(self, action: #selector(vehiclePressed(sender:)), for: .touchUpInside)
        
        return reviews
    }()
    
    var selectionLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PRIMARY_COLOR
        
        return line
    }()
    
    var statusBarColor: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PRIMARY_COLOR
        line.alpha = 0
        
        return line
    }()
    
    var tabFeed: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "feed")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionsTabGestureTapped))
        button.addTarget(self, action: #selector(optionsTabGestureTapped(sender:)), for: .touchUpInside)
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.alpha = 0.9
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let rectShape = CAShapeLayer()
        rectShape.bounds = button.frame
        rectShape.position = button.center
        rectShape.path = UIBezierPath(roundedRect: button.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        button.layer.mask = rectShape
        
        return button
    }()
    
    var optionsTabView: UIView = {
        let optionsTabView = UIView()
        optionsTabView.translatesAutoresizingMaskIntoConstraints = false
        optionsTabView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        
        return optionsTabView
    }()
    
    var optionsTableView: UITableView = {
        let parking = UITableView()
        parking.translatesAutoresizingMaskIntoConstraints = false
        parking.isScrollEnabled = false
        parking.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        
        return parking
    }()
    
    var Main = ["Profile", "Hosting", "Vehicle", "Options"]
    var Options = ["", "Main", "Coupons", "Settings", "Terms", "Contact us!", "Logout"]
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.OFF_WHITE
        self.tabBarController?.tabBar.isHidden = true
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        contentScrollView.delegate = self
        
        effect = visualBlurEffect.effect
        visualBlurEffect.effect = nil
        UIApplication.shared.statusBarStyle = .lightContent
        
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(segmentRight(sender:)))
        gestureRight.direction = .right
        self.view.addGestureRecognizer(gestureRight)
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(segmentLeft(sender:)))
        gestureLeft.direction = .left
        self.view.addGestureRecognizer(gestureLeft)

        setupTopView()
        setupProfileViews()
        setupParkingViews()
        setupVehicleViews()
        setupLine()
        fetchUser()
        setupOptions()
        startUpActivity()
        setupMainTableView()
    }
    
    @objc func segmentRight(sender: UISwipeGestureRecognizer) {
        if self.vehicleViewAnchor.constant == 0 && self.optionsTabViewConstraint.constant == 0 {
            self.openMainOptions()
        } else if self.vehicleViewAnchor.constant == 0 {
            self.parkingPressedFunc()
        } else if self.parkingViewAnchor.constant == 0 {
            self.recentPressedFunc()
        }
    }
    
    @objc func segmentLeft(sender: UISwipeGestureRecognizer) {
        if self.profileViewAnchor.constant == 0 {
            self.parkingPressedFunc()
        } else if self.parkingViewAnchor.constant == 0 {
            self.vehiclePressedFunc()
        } else {
            self.openMainOptions()
        }
    }
    
    var blurSquare: UIVisualEffectView!
    
    func startUpActivity() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurSquare = UIVisualEffectView(effect: blurEffect)
        blurSquare.layer.cornerRadius = 15
        blurSquare.alpha = 1
        blurSquare.clipsToBounds = true
        blurSquare.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(blurSquare)
        blurSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurSquare.widthAnchor.constraint(equalToConstant: 120).isActive = true
        blurSquare.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(startActivityIndicatorView)
        
        startActivityIndicatorView.centerXAnchor.constraint(equalTo: blurSquare.centerXAnchor).isActive = true
        startActivityIndicatorView.centerYAnchor.constraint(equalTo: blurSquare.centerYAnchor).isActive = true
        startActivityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        startActivityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.startActivityIndicatorView.startAnimating()
        
    }
    
    func setupTopView() {
        
        self.view.addSubview(contentScrollView)
        contentScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        contentScrollView.addSubview(profileWrap)
        profileWrap.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        profileWrap.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        profileWrap.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: -statusBarHeight).isActive = true
        switch device {
        case .iphone8:
            profileWrap.heightAnchor.constraint(equalToConstant: 120).isActive = true
        case .iphoneX:
            profileWrap.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        self.view.addSubview(segmentControlView)
        self.view.sendSubview(toBack: segmentControlView)
        controlTopAnchor1 = segmentControlView.topAnchor.constraint(equalTo: profileWrap.bottomAnchor)
        controlTopAnchor1.isActive = true
        controlTopAnchor2 = segmentControlView.topAnchor.constraint(equalTo: view.topAnchor)
        controlTopAnchor2.isActive = false
        segmentControlView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        segmentControlView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentControlView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileWrap.addSubview(profileImageView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView(sender:)))
        profileImageView.addGestureRecognizer(gesture)
        profileImageView.leftAnchor.constraint(equalTo: profileWrap.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: profileWrap.centerYAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        profileWrap.addSubview(addButton)
        addButton.addGestureRecognizer(gesture)
        addButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 25).isActive = true
        addButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor, constant: 25).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        profileWrap.addSubview(profileName)
        profileName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        profileName.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 15).isActive = true
        profileName.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    var profileViewAnchor: NSLayoutConstraint!
    
    func setupProfileViews() {

        contentScrollView.addSubview(profileView)
        profileView.topAnchor.constraint(equalTo: profileWrap.bottomAnchor).isActive = true
        profileViewAnchor = profileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            profileViewAnchor.isActive = true
        profileView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        segmentControlView.addSubview(profileSegment)
        profileSegment.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        profileSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor, constant: 10).isActive = true
        profileSegment.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        profileView.addSubview(currentController.view)
        currentController.didMove(toParentViewController: self)
        currentController.view.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        currentController.view.widthAnchor.constraint(equalTo: profileView.widthAnchor).isActive = true
        currentController.view.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 30).isActive = true
        currentHeightAnchor = currentController.view.heightAnchor.constraint(equalToConstant: 0)
        currentController.view.alpha = 0
        currentHeightAnchor?.isActive = true
        
        profileView.addSubview(recentController.view)
        recentController.didMove(toParentViewController: self)
        recentController.view.centerXAnchor.constraint(equalTo: currentController.view.centerXAnchor).isActive = true
        recentController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        recentController.view.topAnchor.constraint(equalTo: currentController.view.bottomAnchor, constant: 30).isActive = true
        recentController.view.heightAnchor.constraint(equalToConstant: 190).isActive = true

    }
    
    var parkingViewAnchor: NSLayoutConstraint!
    
    func setupParkingViews() {
        
        contentScrollView.addSubview(parkingView)
        parkingView.topAnchor.constraint(equalTo: profileWrap.bottomAnchor).isActive = true
        parkingViewAnchor = parkingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            parkingViewAnchor.isActive = true
        parkingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        parkingView.addSubview(parkingController.view)
        self.addChildViewController(parkingController)
        parkingController.didMove(toParentViewController: self)
        parkingController.view.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
        parkingController.view.widthAnchor.constraint(equalTo: parkingView.widthAnchor).isActive = true
        parkingController.view.topAnchor.constraint(equalTo: parkingView.topAnchor).isActive = true
        parkingController.view.heightAnchor.constraint(equalToConstant: 1600).isActive = true
        
        self.view.addSubview(parkingSegment)
        parkingSegment.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
        parkingSegment.centerYAnchor.constraint(equalTo: profileSegment.centerYAnchor).isActive = true
        parkingSegment.heightAnchor.constraint(equalToConstant: 40).isActive = true
        parkingSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
    }
    
    var vehicleViewAnchor: NSLayoutConstraint!
    
    func setupVehicleViews() {

        contentScrollView.addSubview(vehicleView)
        vehicleView.topAnchor.constraint(equalTo: profileWrap.bottomAnchor).isActive = true
        vehicleViewAnchor = vehicleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            vehicleViewAnchor.isActive = true
        vehicleView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        vehicleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        segmentControlView.addSubview(vehicleSegment)
        vehicleSegment.centerXAnchor.constraint(equalTo: vehicleView.centerXAnchor).isActive = true
        vehicleSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor, constant: 10).isActive = true
        vehicleSegment.heightAnchor.constraint(equalToConstant: 40).isActive = true
        vehicleSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        vehicleView.addSubview(vehicleController.view)
        vehicleController.didMove(toParentViewController: self)
        vehicleController.view.centerXAnchor.constraint(equalTo: vehicleView.centerXAnchor).isActive = true
        vehicleController.view.widthAnchor.constraint(equalTo: vehicleView.widthAnchor).isActive = true
        vehicleController.view.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 70).isActive = true
        vehicleController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
    }
    
    var controlTopAnchor1: NSLayoutConstraint!
    var controlTopAnchor2: NSLayoutConstraint!
    
    func setupLine() {
    
        contentScrollView.addSubview(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: vehicleSegment.bottomAnchor).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        selectionLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(statusBarColor)
        let statusHeight = UIApplication.shared.statusBarFrame.height
        statusBarColor.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        statusBarColor.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        statusBarColor.heightAnchor.constraint(equalToConstant: statusHeight).isActive = true
        statusBarColor.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.addChildViewController(parkingController)
    }
    
    var currentHeightAnchor: NSLayoutConstraint?
    lazy var currentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
    
    func changeCurrentView(height: CGFloat) {
        self.currentController.view.alpha = 1
        self.currentHeightAnchor?.constant = height
        if height >= 200 {
            contentScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
            currentSize = contentScrollView.contentSize
        } else {
            contentScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 50)
            currentSize = contentScrollView.contentSize
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func recentPressed(sender: UIButton) {
        recentPressedFunc()
    }
    
    func recentPressedFunc() {
        contentScrollView.contentSize = currentSize
        profileViewAnchor?.constant = 0
        parkingViewAnchor?.constant = self.view.frame.width
        vehicleViewAnchor?.constant = self.view.frame.width
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func parkingPressed(sender: UIButton) {
        parkingPressedFunc()
    }
    
    func parkingPressedFunc() {
        contentScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2.5)
        profileViewAnchor?.constant = -(self.view.frame.width)*2
        parkingViewAnchor?.constant = 0
        vehicleViewAnchor?.constant = self.view.frame.width
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func vehiclePressed(sender: UIButton) {
        vehiclePressedFunc()
    }
    
    func vehiclePressedFunc() {
        contentScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 50)
        profileViewAnchor?.constant = -(self.view.frame.width)*2
        parkingViewAnchor?.constant = -(self.view.frame.width)*2
        vehicleViewAnchor?.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 90 {
            UIApplication.shared.statusBarStyle = .lightContent
            UIView.animate(withDuration: 0.3) {
                self.statusBarColor.alpha = 0.9
            }
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
            UIView.animate(withDuration: 0.3) {
                self.statusBarColor.alpha = 0
            }
        }
    }
    
    var pickerProfile: UIImagePickerController?
    
    @objc func handleSelectProfileImageView(sender: UITapGestureRecognizer) {
        pickerProfile = UIImagePickerController()
        pickerProfile?.delegate = self
        pickerProfile?.allowsEditing = true
        
        present(pickerProfile!, animated: true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            if picker == pickerProfile {
                profileImageView.image = selectedImage
            }
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let imageName = NSUUID().uuidString
        
        if picker == pickerProfile {
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.5) {
                //        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        guard let profileImageURL = url?.absoluteString else {
                            print("Error finding image url:", error!)
                            return
                        }
                        let values = ["picture": profileImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    })
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let userName = dictionary["name"] as? String {
                    var fullNameArr = userName.split(separator: " ")
                    let firstName: String = String(fullNameArr[0])
                    self.profileName.text = firstName
                }
                if let email = dictionary["email"] as? String {
                    userEmail = email
                }
                let userPicture = dictionary["picture"] as? String
                if userPicture == "" {
                    self.profileImageView.image = UIImage(named: "background4")
                    self.addButton.alpha = 1
                } else {
                    self.profileImageView.loadImageUsingCacheWithUrlString(userPicture!)
                    self.addButton.alpha = 0
                }
            }
            self.startActivityIndicatorView.stopAnimating()
            self.blurSquare.alpha = 0
        }, withCancel: nil)
        return
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginManager = LoginManager()
            loginManager.logOut()
        } catch let logoutError {
            print(logoutError)
        }
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartUpViewController") as! StartUpViewController
            present(viewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tabPullWidthShort: NSLayoutConstraint!
    var tabPullWidthLong: NSLayoutConstraint!
    var optionsTabViewConstraint: NSLayoutConstraint!
    
    func setupOptions() {
        
        self.view.addSubview(optionsTabView)
        optionsTabViewConstraint = optionsTabView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 120)
        optionsTabViewConstraint.isActive = true
        optionsTabView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        optionsTabView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        optionsTabView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(optionsTableView)
        optionsTableView.leftAnchor.constraint(equalTo: optionsTabView.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: optionsTabView.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        optionsTableView.topAnchor.constraint(equalTo: profileWrap.bottomAnchor).isActive = true
        
        self.view.addSubview(tabFeed)
        tabFeed.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
        tabFeed.topAnchor.constraint(equalTo: profileWrap.bottomAnchor, constant: 10).isActive = true
        tabFeed.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tabFeed.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    var bankAnchor: NSLayoutConstraint!
    
    func setupBankAccount() {
        
        self.view.addSubview(bankController.view)
        bankController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bankAnchor = bankController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
        bankAnchor.isActive = true
        bankController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bankController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.bankAnchor.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                UIApplication.shared.statusBarStyle = .default
            })
        }
    }
    
    func removeBankAccountView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bankAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.bankController.view.removeFromSuperview()
            UIApplication.shared.statusBarStyle = .lightContent
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == optionsTableView {
            return Options.count
        } else {
            return Main.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == optionsTableView {
            cell.textLabel?.text = Options[indexPath.row]
            if indexPath.row == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0)
            }
        } else {
            cell.textLabel?.text = Main[indexPath.row]
        }
        cell.textLabel?.textColor = Theme.WHITE
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == optionsTableView {
            if indexPath.row == (Options.count-1) {
                handleLogout()
                self.openMainOptions()
            } else if indexPath.row == (Options.count-2) {
                
                self.view.addSubview(self.contactController.view)
                self.addChildViewController(contactController)
                self.contactController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                self.contactController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                self.contactController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                self.contactController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
                self.contactController.view.alpha = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.contactController.view.alpha = 1
                    })
                }
                self.openMainOptions()
            } else if indexPath.row == (Options.count-3) {
                
                self.view.addSubview(self.termsController.view)
                self.addChildViewController(termsController)
                self.termsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                self.termsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                self.termsController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                self.termsController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
                self.termsController.view.alpha = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.termsController.view.alpha = 1
                    })
                }
                self.openMainOptions()
            } else if indexPath.row == (Options.count-5) {
                
                self.view.addSubview(self.couponController.view)
                self.addChildViewController(couponController)
                self.couponController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                self.couponController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                self.couponController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                self.couponController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
                self.couponController.view.alpha = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.couponController.view.alpha = 1
                    })
                }
                self.openMainOptions()
            } else if indexPath.row == (Options.count-6) {
                self.optionsTabViewConstraint.constant = 120
                UIView.animate(withDuration: 0.1, animations: {
                    let image = UIImage(named: "feed")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    self.tabFeed.setImage(tintedImage, for: .normal)
                    self.tabFeed.tintColor = Theme.DARK_GRAY
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainTableHeight.constant = 175
                        self.mainView.alpha = 0.9
                        let image = UIImage(named: "feed")
                        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                        self.tabFeed.setImage(tintedImage, for: .normal)
                        self.tabFeed.tintColor = Theme.WHITE
                        self.tabFeed.layer.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8).cgColor
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        UIView.animate(withDuration: 0.2) {
                            self.mainTableView.alpha = 1
                        }
                    }
                }
            }
        } else {
            if indexPath.row == (Main.count-1) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.mainTableView.alpha = 0
                }) { (success) in
                    UIView.animate(withDuration: 0.2, animations: {
                        let image = UIImage(named: "feed")
                        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                        self.tabFeed.setImage(tintedImage, for: .normal)
                        self.tabFeed.tintColor = Theme.DARK_GRAY
                        self.tabFeed.layer.backgroundColor = UIColor.clear.cgColor
                        self.mainTableHeight.constant = 0
                        self.mainView.alpha = 0
                        self.view.layoutIfNeeded()
                }) { (success) in
                        self.optionsTabViewConstraint.constant = 0
                        UIView.animate(withDuration: 0.2) {
                            let image = UIImage(named: "feed")
                            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                            self.tabFeed.setImage(tintedImage, for: .normal)
                            self.tabFeed.tintColor = Theme.WHITE
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            } else if indexPath.row == (Main.count-2) {
                self.vehiclePressedFunc()
                self.openMainOptions()
            } else if indexPath.row == (Main.count-3) {
                self.parkingPressedFunc()
                self.openMainOptions()
            } else if indexPath.row == (Main.count-4) {
                self.recentPressedFunc()
                self.openMainOptions()
            }
        }
    }
    
    func removeOptionsFromView() {
        contactController.willMove(toParentViewController: nil)
        contactController.view.removeFromSuperview()
        contactController.removeFromParentViewController()
        termsController.willMove(toParentViewController: nil)
        termsController.view.removeFromSuperview()
        termsController.removeFromParentViewController()
        couponController.willMove(toParentViewController: nil)
        couponController.view.removeFromSuperview()
        couponController.removeFromParentViewController()
    }
    
    lazy var contactController: ContactUsViewController = {
        let controller = ContactUsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Contact Us!"
        controller.view.alpha = 0
        controller.delegate = self
        return controller
    }()
    
    lazy var termsController: TermsViewController = {
        let controller = TermsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Terms"
        controller.view.alpha = 0
        controller.delegateOptions = self
        return controller
    }()
    
    lazy var couponController: CouponsViewController = {
        let controller = CouponsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Coupons"
        controller.view.alpha = 0
        controller.delegate = self
        return controller
    }()
    
    var mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 175))
        view.layer.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8).cgColor
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        view.layer.mask = rectShape
        view.alpha = 0
        
        return view
    }()
    
    var mainTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.alpha = 0
        
        return view
    }()
    
    var mainTableHeight: NSLayoutConstraint!
    
    func setupMainTableView() {
        self.view.addSubview(mainView)
        mainView.rightAnchor.constraint(equalTo: tabFeed.rightAnchor).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainView.topAnchor.constraint(equalTo: tabFeed.bottomAnchor).isActive = true
        mainTableHeight = mainView.heightAnchor.constraint(equalToConstant: 0)
            mainTableHeight.isActive = true
        
        mainView.addSubview(mainTableView)
        mainTableView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        mainTableView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
    }
    
    func openMainOptions() {
        if mainView.alpha == 0 && optionsTabViewConstraint.constant == 120 {
            UIView.animate(withDuration: 0.2, animations: {
                self.mainTableHeight.constant = 175
                self.mainView.alpha = 0.9
                let image = UIImage(named: "feed")
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.tabFeed.setImage(tintedImage, for: .normal)
                self.tabFeed.tintColor = Theme.WHITE
                self.tabFeed.layer.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8).cgColor
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.mainTableView.alpha = 1
                }, completion: nil)
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.mainTableView.alpha = 0
                self.optionsTabViewConstraint.constant = 120
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    let image = UIImage(named: "feed")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    self.tabFeed.setImage(tintedImage, for: .normal)
                    self.tabFeed.tintColor = Theme.DARK_GRAY
                    self.tabFeed.layer.backgroundColor = UIColor.clear.cgColor
                    self.mainTableHeight.constant = 0
                    self.mainView.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func optionsTabGestureTapped(sender: UIButton) {
        openMainOptions()
    }
    
    func setupAddAVehicle() {
        self.delegate?.setupNewVehicle(vehicleStatus: .noVehicle)
    }
    
    func setupAddAParkingSpot() {
        self.delegate?.setupNewParking(parkingImage: .noImage)
    }

}



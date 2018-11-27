//
//  InformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import AudioToolbox

var informationScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = UIColor.clear
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isScrollEnabled = false
    
    return scrollView
}()

protocol controlCurrentParkingOptions {
    func extendTimeView()
    func closeExtendTimeView()
    func sendAvailability(availability: Bool)
    func setupLeaveAReview()
    func openMessages()
}

protocol extendTimeController {
    func closeExtendTimeView()
    func openNavigation()
    func closeNavigation()
}

protocol sendNewHostControl {
    func sendNewHost()
}

var isNavigating: Bool = false

class InformationViewController: UIViewController, UIScrollViewDelegate, controlCurrentParkingOptions, controlHoursButton, extendTimeController, sendNewHostControl {
    
    
    var delegate: removePurchaseView?
    var hostDelegate: controlNewHosts?
    var navigationDelegate: controlHoursButton?
    var parkingID: String?
    var parkingLocation: CLLocation?
    
    lazy var infoController: ParkingInfoViewController = {
        let controller = ParkingInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Info"
        return controller
    }()
    
    lazy var reserveController: ParkingDetailsViewController = {
        let controller = ParkingDetailsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reserve"
        controller.view.clipsToBounds = true
//        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var currentController: ParkingCurrentViewController = {
        let controller = ParkingCurrentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Current"
        controller.view.clipsToBounds = true
        controller.delegate = self
        controller.navigationDelegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var pictureController: ParkingImageViewController = {
        let controller = ParkingImageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Image"
        controller.view.clipsToBounds = true
        return controller
    }()
    
    lazy var reviewsController: ParkingReviewsViewController = {
        let controller = ParkingReviewsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reviews"
        controller.view.clipsToBounds = true
        
        return controller
    }()
    
    var signUpContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up today to become a host and make up to an extra $200 per month renting out your driveway!"
        label.font = Fonts.SSPSemiBoldH6
        label.textColor = Theme.SEA_BLUE
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var purchaseController: ExtendTimeViewController = {
        let controller = ExtendTimeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Purchase"
//        controller.view.layer.cornerRadius = 5
        controller.view.alpha = 0
        controller.hoursDelegate = self
        controller.extendDelegate = self
        
        return controller
    }()
    
    var bannerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var bannerController: BannerAdViewController = {
        let controller = BannerAdViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Banner"
        
        return controller
    }()
    
    var smallBannerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8

        return view
    }()
    
    lazy var smallBannerController: BannerHostingViewController = {
        let controller = BannerHostingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Small Banner"
        controller.delegate = self
        
        return controller
    }()
    
    var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        informationScrollView.delegate = self

        setupViewControllers()
        checkCurrentStatus()
    }
    
    func setData(cityAddress: String, imageURL: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, id: String, parkingID: String, parkingDistance: String, rating: Double, message: String) {
        self.parkingID = parkingID
        infoController.setData(cityAddress: cityAddress, parkingCost: parkingCost, formattedAddress: formattedAddress, timestamp: timestamp, parkingDistance: parkingDistance, rating: rating)
        pictureController.setData(imageURL: imageURL)
        reserveController.setData(formattedAddress: formattedAddress, message: message, parkingID: parkingID, id: id)
        reviewsController.setData(parkingID: parkingID)
        currentController.setData(formattedAddress: formattedAddress, message: message, parkingID: parkingID)
        purchaseController.setData(parkingCost: parkingCost, parkingID: parkingID, id: id)
    }
    
    func sendAvailability(availability: Bool) {
        self.delegate?.sendAvailability(availability: availability)
//        self.reserveController.setAvailability(available: availability)
    }
    
    var pictureHeightAnchor: NSLayoutConstraint!
    var reserveContainerHeightAnchor: NSLayoutConstraint!
    var hoursButtonAnchor: NSLayoutConstraint!
    var hoursTopAnchor: NSLayoutConstraint!

    func setupViewControllers() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.view.addSubview(informationScrollView)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(scrollViewDidPan(sender:)))
        gesture.direction = .up
        informationScrollView.addGestureRecognizer(gesture)
        informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1450)
        informationScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        informationScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        informationScrollView.heightAnchor.constraint(equalToConstant: self.view.frame.height - statusBarHeight).isActive = true
        
        informationScrollView.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoController.view.heightAnchor.constraint(equalTo: infoController.parkingView.heightAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: informationScrollView.topAnchor, constant: 8).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(informationPictureHeld(sender:)))
        holdGesture.minimumPressDuration = 0.2
        pictureController.view.addGestureRecognizer(holdGesture)
        
        informationScrollView.addSubview(pictureController.view)
        pictureController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pictureController.view.heightAnchor.constraint(equalTo: pictureController.parkingView.heightAnchor).isActive = true
        pictureHeightAnchor = pictureController.view.topAnchor.constraint(equalTo: infoController.view.bottomAnchor, constant: 10)
            pictureHeightAnchor.isActive = true
        pictureController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        informationScrollView.addSubview(reserveController.view)
        reserveController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reserveController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        reserveController.view.topAnchor.constraint(equalTo: self.pictureController.view.bottomAnchor, constant: 8).isActive = true
        reserveController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        informationScrollView.addSubview(reviewsController.view)
        reviewsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsController.view.heightAnchor.constraint(equalToConstant: 210).isActive = true
        reviewsController.view.topAnchor.constraint(equalTo: reserveController.view.bottomAnchor, constant: 8).isActive = true
        reviewsController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        informationScrollView.addSubview(bannerContainer)
        bannerContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bannerContainer.topAnchor.constraint(equalTo: reviewsController.view.bottomAnchor, constant: 8).isActive = true
        bannerContainer.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        bannerContainer.addSubview(bannerController.view)
        bannerController.view.centerXAnchor.constraint(equalTo: bannerContainer.centerXAnchor).isActive = true
        bannerController.view.widthAnchor.constraint(equalTo: bannerContainer.widthAnchor).isActive = true
        bannerController.view.centerYAnchor.constraint(equalTo: bannerContainer.centerYAnchor).isActive = true
        bannerController.view.heightAnchor.constraint(equalTo: bannerContainer.heightAnchor).isActive = true
        
        
        informationScrollView.addSubview(smallBannerContainer)
        smallBannerContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallBannerContainer.topAnchor.constraint(equalTo: bannerController.view.bottomAnchor, constant: 25).isActive = true
        smallBannerContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        smallBannerContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        smallBannerContainer.addSubview(smallBannerController.view)
        smallBannerController.view.centerXAnchor.constraint(equalTo: smallBannerContainer.centerXAnchor).isActive = true
        smallBannerController.view.centerYAnchor.constraint(equalTo: smallBannerContainer.centerYAnchor).isActive = true
        smallBannerController.view.heightAnchor.constraint(equalTo: smallBannerContainer.heightAnchor).isActive = true
        smallBannerController.view.widthAnchor.constraint(equalTo: smallBannerContainer.widthAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(informationPictureTapped(sender:)))
        blurView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }
    
    var playOnce: Bool = false
    
    @objc func informationPictureHeld(sender: UILongPressGestureRecognizer) {
        if self.playOnce == false {
            self.playOnce = true
            AudioServicesPlaySystemSound(1519)
        }
        UIView.animate(withDuration: animationIn) {
            self.view.clipsToBounds = false
            informationScrollView.contentOffset.y = 0
            informationScrollView.isScrollEnabled = false
            informationScrollView.isUserInteractionEnabled = false
            self.blurView.alpha = 1
            self.infoController.view.alpha = 0
            self.reserveController.view.alpha = 0
            self.pictureController.parkingView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    @objc func informationPictureTapped(sender: UITapGestureRecognizer) {
        self.playOnce = false
        UIView.animate(withDuration: animationIn) {
            self.view.clipsToBounds = true
            informationScrollView.isScrollEnabled = true
            informationScrollView.isUserInteractionEnabled = true
            self.blurView.alpha = 0
            self.infoController.view.alpha = 1
            self.reserveController.view.alpha = 1
            self.pictureController.parkingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == informationScrollView {
            if scrollView.contentOffset.y <= 5.0 && scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
                informationScrollView.isScrollEnabled = false
            } else if scrollView.contentOffset.y >= 5.0 {
                informationScrollView.isScrollEnabled = true
            }
//            scrollView.contentOffset.y = scrollView.contentOffset.y/2
        }
    }
    
    @objc func scrollViewDidPan(sender: UISwipeGestureRecognizer) {
        informationScrollView.isScrollEnabled = true
    }
    
    var check: Bool = true
    
    func checkCurrentStatus() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("currentParking")
        ref.observe(.childAdded) { (snapshot) in
            self.check = false
            UIView.animate(withDuration: animationIn, animations: {
                informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1500)
                self.reserveContainerHeightAnchor.constant = 165
                self.currentController.view.alpha = 1
                self.reserveController.view.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.check = false
            UIView.animate(withDuration: animationIn, animations: {
                informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1450)
                self.reserveContainerHeightAnchor.constant = 120
                self.currentController.view.alpha = 0
                self.reserveController.view.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        if check == true {
            UIView.animate(withDuration: animationIn, animations: {
                self.currentController.view.alpha = 0
                self.reserveController.view.alpha = 1
            })
        }
    }
    
    func extendTimeView() {
        if self.purchaseController.view.alpha >= 0.1 {
            self.closeExtendTimeView()
        } else {
            UIView.animate(withDuration: animationIn, animations: {
                self.pictureHeightAnchor.constant = 100
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.purchaseController.view.alpha = 1
                })
            }
        }
    }
    
    func closeExtendTimeView() {
        UIView.animate(withDuration: animationIn, animations: {
            self.purchaseController.view.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.pictureHeightAnchor.constant = 10
                self.view.layoutIfNeeded()
            })
            self.closeNavigation()
        }
    }
    
    func openNavigation() {
        isNavigating = true
        self.currentParkingDisappear()
        self.navigationDelegate?.drawCurrentPath(dest: self.parkingLocation!, navigation: true)
    }
    
    func closeNavigation() {
        isNavigating = false
        self.currentParkingDisappear()
        self.navigationDelegate?.hideNavigation()
    }
    
    func currentParkingDisappear() {
        self.navigationDelegate?.currentParkingDisappear()
    }
    
    func openHoursButton() {
        self.hoursButtonAnchor.constant = 200
        self.hoursTopAnchor.constant = -110
        self.view.layoutIfNeeded()
    }
    
    func closeHoursButton() {
        self.hoursButtonAnchor.constant = 80
        self.hoursTopAnchor.constant = 10
        self.view.layoutIfNeeded()
    }
    
    func setupLeaveAReview() {
        self.delegate?.setupLeaveAReview(parkingID: self.parkingID!)
    }
    
    func sendNewHost() {
        self.hostDelegate?.sendNewHost()
    }
    
    func openMessages() {
        self.delegate?.openMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawCurrentPath(dest: CLLocation, navigation: Bool) {}
    func hideNavigation() {}
    

}

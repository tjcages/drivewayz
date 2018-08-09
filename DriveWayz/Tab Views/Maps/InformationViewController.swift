//
//  InformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

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
}

protocol extendTimeController {
    func closeExtendTimeView()
}

protocol sendNewHostControl {
    func sendNewHost()
}

class InformationViewController: UIViewController, UIScrollViewDelegate, controlCurrentParkingOptions, controlHoursButton, extendTimeController, sendNewHostControl {
    
    var delegate: removePurchaseView?
    var hostDelegate: controlNewHosts?
    var parkingID: String?
    
    lazy var infoController: ParkingInfoViewController = {
        let controller = ParkingInfoViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Info"
        return controller
    }()
    
    var infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 1
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var reserveController: ParkingReserveViewController = {
        let controller = ParkingReserveViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reserve"
        controller.view.layer.cornerRadius = 5
        controller.view.clipsToBounds = true
        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var currentController: ParkingCurrentViewController = {
        let controller = ParkingCurrentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Current"
        controller.view.layer.cornerRadius = 5
        controller.view.clipsToBounds = true
        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    var reserveContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var pictureController: ParkingImageViewController = {
        let controller = ParkingImageViewController()
//        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Image"
        controller.view.layer.cornerRadius = 5
        controller.view.clipsToBounds = true
        return controller
    }()
    
    var pictureContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var availabilityController: ParkingAvailabilityViewController = {
        let controller = ParkingAvailabilityViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Availability"
        controller.view.layer.cornerRadius = 5
        controller.view.clipsToBounds = true
        controller.delegate = self
        
        return controller
    }()
    
    var availabilityContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var reviewsController: ParkingReviewsViewController = {
        let controller = ParkingReviewsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reviews"
        controller.view.layer.cornerRadius = 5
        controller.view.clipsToBounds = true
        
        return controller
    }()
    
    var reviewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    var signUpContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up today to become a host and make up to an extra $200 per month renting out your driveway!"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var purchaseController: ExtendTimeViewController = {
        let controller = ExtendTimeViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Purchase"
        controller.view.layer.cornerRadius = 5
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
        view.layer.cornerRadius = 5
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
        view.layer.cornerRadius = 5
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
        availabilityController.setData(id: id)
        reviewsController.setData(parkingID: parkingID)
        currentController.setData(formattedAddress: formattedAddress, message: message, parkingID: parkingID)
        purchaseController.setData(parkingCost: parkingCost, parkingID: parkingID, id: id)
    }
    
    func sendAvailability(availability: Bool) {
        self.delegate?.sendAvailability(availability: availability)
        self.reserveController.setAvailability(available: availability)
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
        informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1400)
        informationScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        informationScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        informationScrollView.heightAnchor.constraint(equalToConstant: self.view.frame.height - statusBarHeight).isActive = true
        
        informationScrollView.addSubview(infoContainer)
        infoContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        infoContainer.topAnchor.constraint(equalTo: informationScrollView.topAnchor, constant: 5).isActive = true
        infoContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        infoContainer.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: infoContainer.centerXAnchor).isActive = true
        infoController.view.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: infoContainer.topAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
        
        
        informationScrollView.addSubview(reserveContainer)
        reserveContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reserveContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reserveContainer.topAnchor.constraint(equalTo: self.infoContainer.bottomAnchor, constant: 10).isActive = true
        reserveContainerHeightAnchor = reserveContainer.heightAnchor.constraint(equalToConstant: 120)
            reserveContainerHeightAnchor.isActive = true
        
        reserveContainer.addSubview(reserveController.view)
        reserveController.view.centerXAnchor.constraint(equalTo: self.reserveContainer.centerXAnchor).isActive = true
        reserveController.view.bottomAnchor.constraint(equalTo: self.reserveContainer.bottomAnchor).isActive = true
        reserveController.view.topAnchor.constraint(equalTo: self.reserveContainer.topAnchor).isActive = true
        reserveController.view.widthAnchor.constraint(equalTo: self.reserveContainer.widthAnchor).isActive = true

        
        reserveContainer.addSubview(currentController.view)
        currentController.view.centerXAnchor.constraint(equalTo: self.reserveContainer.centerXAnchor).isActive = true
        currentController.view.bottomAnchor.constraint(equalTo: self.reserveContainer.bottomAnchor).isActive = true
        currentController.view.topAnchor.constraint(equalTo: self.reserveContainer.topAnchor).isActive = true
        currentController.view.widthAnchor.constraint(equalTo: self.reserveContainer.widthAnchor).isActive = true
        
        
        informationScrollView.addSubview(purchaseController.view)
//        self.addChildViewController(purchaseController)
        purchaseController.didMove(toParentViewController: self)
        purchaseController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        hoursTopAnchor = purchaseController.view.topAnchor.constraint(equalTo: reserveContainer.bottomAnchor, constant: 10)
            hoursTopAnchor.isActive = true
        hoursButtonAnchor = purchaseController.view.heightAnchor.constraint(equalToConstant: 80)
            hoursButtonAnchor.isActive = true
        
        
        informationScrollView.addSubview(pictureContainer)
        pictureContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pictureContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pictureHeightAnchor = pictureContainer.topAnchor.constraint(equalTo: reserveContainer.bottomAnchor, constant: 10)
            pictureHeightAnchor.isActive = true
        pictureContainer.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        pictureContainer.addSubview(pictureController.view)
        pictureController.view.centerXAnchor.constraint(equalTo: pictureContainer.centerXAnchor).isActive = true
        pictureController.view.bottomAnchor.constraint(equalTo: pictureContainer.bottomAnchor).isActive = true
        pictureController.view.topAnchor.constraint(equalTo: pictureContainer.topAnchor).isActive = true
        pictureController.view.widthAnchor.constraint(equalTo: pictureContainer.widthAnchor).isActive = true
        
        
        informationScrollView.addSubview(availabilityContainer)
        availabilityContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        availabilityContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        availabilityContainer.topAnchor.constraint(equalTo: pictureContainer.bottomAnchor, constant: 10).isActive = true
        availabilityContainer.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        availabilityContainer.addSubview(availabilityController.view)
        availabilityController.view.centerXAnchor.constraint(equalTo: availabilityContainer.centerXAnchor).isActive = true
        availabilityController.view.bottomAnchor.constraint(equalTo: availabilityContainer.bottomAnchor).isActive = true
        availabilityController.view.topAnchor.constraint(equalTo: availabilityContainer.topAnchor).isActive = true
        availabilityController.view.widthAnchor.constraint(equalTo: availabilityContainer.widthAnchor).isActive = true
        
        informationScrollView.addSubview(reviewsContainer)
        reviewsContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsContainer.topAnchor.constraint(equalTo: availabilityContainer.bottomAnchor, constant: 10).isActive = true
        reviewsContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        reviewsContainer.addSubview(reviewsController.view)
        reviewsController.view.centerXAnchor.constraint(equalTo: reviewsContainer.centerXAnchor).isActive = true
        reviewsController.view.bottomAnchor.constraint(equalTo: reviewsContainer.bottomAnchor).isActive = true
        reviewsController.view.topAnchor.constraint(equalTo: reviewsContainer.topAnchor).isActive = true
        reviewsController.view.widthAnchor.constraint(equalTo: reviewsContainer.widthAnchor).isActive = true
        
    
        informationScrollView.addSubview(bannerContainer)
        bannerContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bannerContainer.topAnchor.constraint(equalTo: reviewsContainer.bottomAnchor, constant: 10).isActive = true
        bannerContainer.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        bannerContainer.addSubview(bannerController.view)
        bannerController.view.centerXAnchor.constraint(equalTo: bannerContainer.centerXAnchor).isActive = true
        bannerController.view.widthAnchor.constraint(equalTo: bannerContainer.widthAnchor).isActive = true
        bannerController.view.centerYAnchor.constraint(equalTo: bannerContainer.centerYAnchor).isActive = true
        bannerController.view.heightAnchor.constraint(equalTo: bannerContainer.heightAnchor).isActive = true
        
        
        informationScrollView.addSubview(smallBannerContainer)
        smallBannerContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallBannerContainer.topAnchor.constraint(equalTo: bannerController.view.bottomAnchor, constant: 10).isActive = true
        smallBannerContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        smallBannerContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        smallBannerContainer.addSubview(smallBannerController.view)
        smallBannerController.view.centerXAnchor.constraint(equalTo: smallBannerContainer.centerXAnchor).isActive = true
        smallBannerController.view.centerYAnchor.constraint(equalTo: smallBannerContainer.centerYAnchor).isActive = true
        smallBannerController.view.heightAnchor.constraint(equalTo: smallBannerContainer.heightAnchor).isActive = true
        smallBannerController.view.widthAnchor.constraint(equalTo: smallBannerContainer.widthAnchor).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == informationScrollView {
            if scrollView.contentOffset.y <= 5.0 && scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
                informationScrollView.isScrollEnabled = false
            } else if scrollView.contentOffset.y >= 5.0 {
                informationScrollView.isScrollEnabled = true
            }
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
            UIView.animate(withDuration: 0.3, animations: {
                informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1145)
                self.reserveContainerHeightAnchor.constant = 165
                self.currentController.view.alpha = 1
                self.reserveController.view.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.check = false
            UIView.animate(withDuration: 0.3, animations: {
                informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1100)
                self.reserveContainerHeightAnchor.constant = 120
                self.currentController.view.alpha = 0
                self.reserveController.view.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        if check == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentController.view.alpha = 0
                self.reserveController.view.alpha = 1
            })
        }
    }
    
    func extendTimeView() {
        if self.purchaseController.view.alpha >= 0.1 {
            self.closeExtendTimeView()
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.pictureHeightAnchor.constant = 100
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.purchaseController.view.alpha = 1
                })
            }
        }
    }
    
    func closeExtendTimeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.purchaseController.view.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.pictureHeightAnchor.constant = 10
                self.view.layoutIfNeeded()
            })
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

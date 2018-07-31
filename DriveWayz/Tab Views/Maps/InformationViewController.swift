//
//  InformationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

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
    func addCurrentOptions()
    func removeCurrentOptions()
    func extendTimeView()
    func sendAvailability(availability: Bool)
    func setupLeaveAReview()
}

class InformationViewController: UIViewController, UIScrollViewDelegate, controlCurrentParkingOptions {
    
    var delegate: removePurchaseView?
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
        view.alpha = 0.9
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()
    
    lazy var currentController: ParkingCurrentViewController = {
        let controller = ParkingCurrentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Current"
        controller.view.layer.cornerRadius = 5
        controller.view.clipsToBounds = true
        controller.delegate = self
        
        return controller
    }()
    
    var currentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.9
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
        view.alpha = 0.9
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
        view.alpha = 0.9
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
        view.alpha = 0.9
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
        view.alpha = 0.9
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

    override func viewDidLoad() {
        super.viewDidLoad()
        informationScrollView.delegate = self

        setupViewControllers()
    }
    
    func setData(cityAddress: String, imageURL: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, id: String, parkingID: String, parkingDistance: String, rating: Double, message: String) {
        self.parkingID = parkingID
        infoController.setData(cityAddress: cityAddress, parkingCost: parkingCost, formattedAddress: formattedAddress, timestamp: timestamp, parkingDistance: parkingDistance, rating: rating)
        pictureController.setData(imageURL: imageURL)
        availabilityController.setData(id: id)
        reviewsController.setData(parkingID: parkingID)
        currentController.setData(formattedAddress: formattedAddress, message: message, parkingID: parkingID)
    }
    
    func sendAvailability(availability: Bool) {
        self.delegate?.sendAvailability(availability: availability)
    }
    
    var pictureHeightAnchor: NSLayoutConstraint!

    func setupViewControllers() {
        
        self.view.addSubview(informationScrollView)
        informationScrollView.contentSize = CGSize(width: 500, height: 1100)
        informationScrollView.contentOffset = CGPoint(x: 0, y: 1100)
        informationScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        informationScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        informationScrollView.heightAnchor.constraint(equalToConstant: 650).isActive = true
        
        informationScrollView.addSubview(infoContainer)
        infoContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        infoContainer.bottomAnchor.constraint(equalTo: informationScrollView.bottomAnchor, constant: 1095).isActive = true
        infoContainer.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        infoContainer.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: infoContainer.centerXAnchor).isActive = true
        infoController.view.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: infoContainer.topAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
        
        
        informationScrollView.addSubview(pictureContainer)
        pictureContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pictureContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pictureHeightAnchor = pictureContainer.bottomAnchor.constraint(equalTo: infoContainer.topAnchor, constant: -5)
            pictureHeightAnchor.isActive = true
        pictureContainer.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        pictureContainer.addSubview(pictureController.view)
        pictureController.view.centerXAnchor.constraint(equalTo: pictureContainer.centerXAnchor).isActive = true
        pictureController.view.bottomAnchor.constraint(equalTo: pictureContainer.bottomAnchor).isActive = true
        pictureController.view.topAnchor.constraint(equalTo: pictureContainer.topAnchor).isActive = true
        pictureController.view.widthAnchor.constraint(equalTo: pictureContainer.widthAnchor).isActive = true
        
        
        informationScrollView.addSubview(availabilityContainer)
        availabilityContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        availabilityContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        availabilityContainer.bottomAnchor.constraint(equalTo: pictureContainer.topAnchor, constant: -5).isActive = true
        availabilityContainer.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        availabilityContainer.addSubview(availabilityController.view)
        availabilityController.view.centerXAnchor.constraint(equalTo: availabilityContainer.centerXAnchor).isActive = true
        availabilityController.view.bottomAnchor.constraint(equalTo: availabilityContainer.bottomAnchor).isActive = true
        availabilityController.view.topAnchor.constraint(equalTo: availabilityContainer.topAnchor).isActive = true
        availabilityController.view.widthAnchor.constraint(equalTo: availabilityContainer.widthAnchor).isActive = true
        
        informationScrollView.addSubview(reviewsContainer)
        reviewsContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsContainer.bottomAnchor.constraint(equalTo: availabilityContainer.topAnchor, constant: -5).isActive = true
        reviewsContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        reviewsContainer.addSubview(reviewsController.view)
        reviewsController.view.centerXAnchor.constraint(equalTo: reviewsContainer.centerXAnchor).isActive = true
        reviewsController.view.bottomAnchor.constraint(equalTo: reviewsContainer.bottomAnchor).isActive = true
        reviewsController.view.topAnchor.constraint(equalTo: reviewsContainer.topAnchor).isActive = true
        reviewsController.view.widthAnchor.constraint(equalTo: reviewsContainer.widthAnchor).isActive = true
        
        informationScrollView.addSubview(signUpContainer)
        signUpContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        signUpContainer.bottomAnchor.constraint(equalTo: reviewsContainer.topAnchor, constant: -25).isActive = true
        signUpContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        signUpContainer.addSubview(signUpLabel)
        signUpLabel.leftAnchor.constraint(equalTo: signUpContainer.leftAnchor, constant: 10).isActive = true
        signUpLabel.rightAnchor.constraint(equalTo: signUpContainer.rightAnchor, constant: -10).isActive = true
        signUpLabel.topAnchor.constraint(equalTo: signUpContainer.topAnchor, constant: 10).isActive = true
        signUpLabel.bottomAnchor.constraint(equalTo: signUpContainer.bottomAnchor, constant: -10).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == informationScrollView {
            if scrollView.contentOffset.y >= 465.0 {
                informationScrollView.isScrollEnabled = false
            } else if scrollView.contentOffset.y <= 435.0 {
                informationScrollView.isScrollEnabled = true
            }
        }
    }
    
    func addCurrentOptions() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pictureHeightAnchor.constant = -175
            self.view.layoutIfNeeded()
        }) { (success) in
            
            informationScrollView.addSubview(self.currentContainer)
            self.currentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.currentContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            self.currentContainer.bottomAnchor.constraint(equalTo: self.infoContainer.topAnchor, constant: -5).isActive = true
            self.currentContainer.heightAnchor.constraint(equalToConstant: 165).isActive = true
            
            self.currentContainer.addSubview(self.currentController.view)
            self.currentController.view.centerXAnchor.constraint(equalTo: self.currentContainer.centerXAnchor).isActive = true
            self.currentController.view.bottomAnchor.constraint(equalTo: self.currentContainer.bottomAnchor).isActive = true
            self.currentController.view.topAnchor.constraint(equalTo: self.currentContainer.topAnchor).isActive = true
            self.currentController.view.widthAnchor.constraint(equalTo: self.currentContainer.widthAnchor).isActive = true
        }
    }
    
    func removeCurrentOptions() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pictureHeightAnchor.constant = -5
            self.view.layoutIfNeeded()
        }) { (success) in
            
            self.currentContainer.removeFromSuperview()
            
            self.currentController.willMove(toParentViewController: nil)
            self.currentController.view.removeFromSuperview()
            self.currentController.removeFromParentViewController()
            
        }
    }
    
    func extendTimeView() {
        self.delegate?.extendTimeView()
    }
    
    func setupLeaveAReview() {
        self.delegate?.setupLeaveAReview(parkingID: self.parkingID!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

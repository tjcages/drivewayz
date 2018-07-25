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


class InformationViewController: UIViewController, UIScrollViewDelegate {
    
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
        view.layer.cornerRadius = 10
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
        controller.view.layer.cornerRadius = 10
        controller.view.clipsToBounds = true
        return controller
    }()
    
    var pictureContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
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
        controller.view.layer.cornerRadius = 10
        controller.view.clipsToBounds = true
        
        return controller
    }()
    
    var availabilityContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
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
        controller.view.layer.cornerRadius = 10
        controller.view.clipsToBounds = true
        
        return controller
    }()
    
    var reviewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        informationScrollView.delegate = self

        setupViewControllers()
    }
    
    func setData(cityAddress: String, imageURL: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, id: String, parkingID: String, parkingDistance: String) {
        infoController.setData(cityAddress: cityAddress, parkingCost: parkingCost, formattedAddress: formattedAddress, timestamp: timestamp, parkingDistance: parkingDistance)
        pictureController.setData(imageURL: imageURL)
        availabilityController.setData(id: id)
        reviewsController.setData(parkingID: parkingID)
    }

    func setupViewControllers() {
        
        self.view.addSubview(informationScrollView)
        informationScrollView.contentSize = CGSize(width: 500, height: 1000)
        informationScrollView.contentOffset = CGPoint(x: 0, y: 1000)
        informationScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        informationScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        informationScrollView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        informationScrollView.addSubview(infoContainer)
        infoContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        infoContainer.bottomAnchor.constraint(equalTo: informationScrollView.bottomAnchor, constant: 995).isActive = true
        infoContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        infoContainer.addSubview(infoController.view)
        infoController.view.centerXAnchor.constraint(equalTo: infoContainer.centerXAnchor).isActive = true
        infoController.view.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: infoContainer.topAnchor).isActive = true
        infoController.view.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
        
        
        informationScrollView.addSubview(pictureContainer)
        pictureContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pictureContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pictureContainer.bottomAnchor.constraint(equalTo: infoContainer.topAnchor, constant: -5).isActive = true
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
        availabilityContainer.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        availabilityContainer.addSubview(availabilityController.view)
        availabilityController.view.centerXAnchor.constraint(equalTo: availabilityContainer.centerXAnchor).isActive = true
        availabilityController.view.bottomAnchor.constraint(equalTo: availabilityContainer.bottomAnchor).isActive = true
        availabilityController.view.topAnchor.constraint(equalTo: availabilityContainer.topAnchor).isActive = true
        availabilityController.view.widthAnchor.constraint(equalTo: availabilityContainer.widthAnchor).isActive = true
        
        informationScrollView.addSubview(reviewsContainer)
        reviewsContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsContainer.bottomAnchor.constraint(equalTo: availabilityContainer.topAnchor, constant: -5).isActive = true
        reviewsContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        reviewsContainer.addSubview(reviewsController.view)
        reviewsController.view.centerXAnchor.constraint(equalTo: reviewsContainer.centerXAnchor).isActive = true
        reviewsController.view.bottomAnchor.constraint(equalTo: reviewsContainer.bottomAnchor).isActive = true
        reviewsController.view.topAnchor.constraint(equalTo: reviewsContainer.topAnchor).isActive = true
        reviewsController.view.widthAnchor.constraint(equalTo: reviewsContainer.widthAnchor).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == informationScrollView {
            if scrollView.contentOffset.y >= 415.0 {
                informationScrollView.isScrollEnabled = false
            } else if scrollView.contentOffset.y <= 385.0 {
                informationScrollView.isScrollEnabled = true
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

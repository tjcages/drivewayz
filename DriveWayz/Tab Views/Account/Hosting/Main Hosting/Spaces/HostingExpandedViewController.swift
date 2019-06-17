//
//  HostingExpandedViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostEditing {
    func closeCalendar()
    func closeInformation()
    func closeCost()
    func closeSpots()
    func closeAmenities()
}

class HostingExpandedViewController: UIViewController {
    
    var delegate: handleHostingReservations?
    var height: CGFloat = 0
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.01)
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        view.clipsToBounds = false
        
        return view
    }()
    
    var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1065 University Ave. Boulder, CO"
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var expandedImages: ExpandedImageViewController = {
        let controller = ExpandedImageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedInformation: ExpandedInformationViewController = {
        let controller = ExpandedInformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedCost: ExpandedCostViewController = {
        let controller = ExpandedCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    lazy var expandedNumber: ExpandedSpotsViewController = {
        let controller = ExpandedSpotsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedAmenities: ExpandedAmenitiesViewController = {
        let controller = ExpandedAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var expandedOptions: HostingOptionsViewController = {
        let controller = HostingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var editCalendar: EditCalendarViewController = {
        let controller = EditCalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editInformation: EditInformationViewController = {
        let controller = EditInformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editCost: EditCostViewController = {
        let controller = EditCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editSpots: EditSpotsViewController = {
        let controller = EditSpotsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editAmenities: EditAmenitiesViewController = {
        let controller = EditAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }
    
    func setData(hosting: ParkingSpots) {
        expandedInformation.setData(hosting: hosting)
        expandedCost.setData(hosting: hosting)
        expandedNumber.setData(hosting: hosting)
        expandedAmenities.setData(hosting: hosting)
        expandedImages.setData(hosting: hosting)
        if let overallAddress = hosting.overallAddress {
            self.spotLocatingLabel.text = overallAddress
        }
//        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24 + statusHeight).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36 + statusHeight).isActive = true
        }
        
        scrollView.addSubview(darkView)
        darkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        darkView.heightAnchor.constraint(equalToConstant: 308 + statusHeight).isActive = true
        
        darkView.addSubview(imageContainer)
        imageContainer.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        imageContainer.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        
        imageContainer.addSubview(expandedImages.view)
        expandedImages.view.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        expandedImages.view.leftAnchor.constraint(equalTo: darkView.leftAnchor).isActive = true
        expandedImages.view.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        expandedImages.view.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -50).isActive = true
        
        darkView.addSubview(spotLocatingLabel)
        spotLocatingLabel.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: 0).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: darkView.leftAnchor, constant: 12).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: darkView.rightAnchor, constant: -12).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(expandedInformation.view)
        expandedInformation.view.topAnchor.constraint(equalTo: darkView.bottomAnchor, constant: 0).isActive = true
        expandedInformation.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedInformation.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedInformation.view.heightAnchor.constraint(equalToConstant: expandedInformation.height).isActive = true
        
        scrollView.addSubview(expandedCost.view)
        expandedCost.view.topAnchor.constraint(equalTo: expandedInformation.view.bottomAnchor).isActive = true
        expandedCost.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedCost.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedCost.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.addSubview(expandedNumber.view)
        expandedNumber.view.topAnchor.constraint(equalTo: expandedCost.view.bottomAnchor).isActive = true
        expandedNumber.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedNumber.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedNumber.view.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        scrollView.addSubview(expandedAmenities.view)
        expandedAmenities.view.topAnchor.constraint(equalTo: expandedNumber.view.bottomAnchor).isActive = true
        expandedAmenities.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        expandedAmenities.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedAmenities.view.heightAnchor.constraint(equalToConstant: expandedAmenities.height).isActive = true
        
        scrollView.addSubview(expandedOptions.view)
        expandedOptions.view.topAnchor.constraint(equalTo: expandedAmenities.view.bottomAnchor, constant: 20).isActive = true
        expandedOptions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        expandedOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        expandedOptions.view.heightAnchor.constraint(equalToConstant: 240).isActive = true
        expandedOptions.seeAvailability.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        expandedInformation.editInformation.addTarget(self, action: #selector(openInformation), for: .touchUpInside)
        expandedCost.editInformation.addTarget(self, action: #selector(openCost), for: .touchUpInside)
        expandedNumber.editInformation.addTarget(self, action: #selector(openSpots), for: .touchUpInside)
        expandedAmenities.editInformation.addTarget(self, action: #selector(openAmenities), for: .touchUpInside)
        
        height = expandedInformation.height + 100 + 132 + expandedAmenities.height + 750
        scrollView.contentSize = CGSize(width: phoneWidth, height: height)
        
        self.view.addSubview(editCalendar.view)
        editCalendar.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        editCalendar.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editCalendar.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editCalendar.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(editInformation.view)
        editInformation.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        editInformation.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editInformation.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editInformation.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(editCost.view)
        editCost.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        editCost.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editCost.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editCost.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(editSpots.view)
        editSpots.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        editSpots.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editSpots.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editSpots.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(editAmenities.view)
        editAmenities.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        editAmenities.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editAmenities.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editAmenities.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func backButtonPressed() {
        self.delegate?.returnExpandedPressed()
    }
    
}

extension HostingExpandedViewController: handleHostEditing {
    
    @objc func openCalendar() {
        self.editCalendar.setupPreviousAvailability()
        UIView.animate(withDuration: animationOut, animations: {
            self.editCalendar.view.alpha = 1
        }) { (success) in
            self.delegate?.lightContentStatusBar()
        }
    }
    
    func closeCalendar() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editCalendar.view.alpha = 0
        }) { (success) in
            self.checkStatusBar()
        }
    }
    
    @objc func openInformation() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editInformation.view.alpha = 1
        }) { (success) in
            self.delegate?.lightContentStatusBar()
        }
    }
    
    func closeInformation() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editInformation.view.alpha = 0
        }) { (success) in
            self.checkStatusBar()
        }
    }
    
    @objc func openCost() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editCost.view.alpha = 1
        }) { (success) in
            self.delegate?.lightContentStatusBar()
        }
    }
    
    func closeCost() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editCost.view.alpha = 0
        }) { (success) in
            self.checkStatusBar()
        }
    }
    
    @objc func openSpots() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editSpots.view.alpha = 1
        }) { (success) in
            self.delegate?.lightContentStatusBar()
        }
    }
    
    func closeSpots() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editSpots.view.alpha = 0
        }) { (success) in
            self.checkStatusBar()
        }
    }
    
    @objc func openAmenities() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editAmenities.view.alpha = 1
        }) { (success) in
            self.delegate?.lightContentStatusBar()
        }
    }
    
    func closeAmenities() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editAmenities.view.alpha = 0
        }) { (success) in
            self.checkStatusBar()
        }
    }
    
    func checkStatusBar() {
        let translation = scrollView.contentOffset.y
        if translation >= 180 {
            self.delegate?.darkContentStatusBar()
        } else {
            self.delegate?.lightContentStatusBar()
        }
    }
    
}

extension HostingExpandedViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        UIView.animate(withDuration: animationIn) {
            if translation >= 180 {
                self.delegate?.darkContentStatusBar()
                self.backButton.tintColor = Theme.BLACK
            } else if translation <= -30.0 {
                self.backButtonPressed()
            } else {
                self.delegate?.lightContentStatusBar()
                self.backButton.tintColor = Theme.WHITE
            }
        }
    }
    
}

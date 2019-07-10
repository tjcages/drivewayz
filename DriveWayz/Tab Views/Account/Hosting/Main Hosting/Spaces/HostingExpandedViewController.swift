//
//  HostingExpandedViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingExpandedViewController: UIViewController {
    
    var delegate: handleHostingReservations?
    var statusBarColor = true
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
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = ""
        label.font = Fonts.SSPRegularH3
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        
        return label
    }()
    
    var gradientLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = ""
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        
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
        
        return controller
    }()
    
    lazy var editInformation: EditInformationViewController = {
        let controller = EditInformationViewController()
        
        return controller
    }()
    
    lazy var editCost: EditCostViewController = {
        let controller = EditCostViewController()
        
        return controller
    }()
    
    lazy var editSpots: EditSpotsViewController = {
        let controller = EditSpotsViewController()
        
        return controller
    }()
    
    lazy var editAmenities: EditAmenitiesViewController = {
        let controller = EditAmenitiesViewController()
        
        return controller
    }()
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
    }
    
    func setData(hosting: ParkingSpots) {
        expandedInformation.setData(hosting: hosting)
        expandedCost.setData(hosting: hosting)
        expandedNumber.setData(hosting: hosting)
        expandedAmenities.setData(hosting: hosting)
        expandedImages.setData(hosting: hosting)
        editCost.setData(parking: hosting)
        if let overallAddress = hosting.overallAddress, let streetAddress = hosting.streetAddress {
            self.spotLocatingLabel.text = overallAddress
            self.gradientLocatingLabel.text = streetAddress
        }
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -statusHeight).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        scrollView.addSubview(darkView)
        darkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        darkView.heightAnchor.constraint(equalToConstant: 308 + statusHeight).isActive = true
        
        darkView.addSubview(imageContainer)
        imageContainer.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imageContainer.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        
        imageContainer.addSubview(expandedImages.view)
        expandedImages.view.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        expandedImages.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        expandedImages.view.rightAnchor.constraint(equalTo: darkView.rightAnchor).isActive = true
        expandedImages.view.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -50).isActive = true
        
        darkView.addSubview(spotLocatingLabel)
        spotLocatingLabel.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: 0).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: darkView.rightAnchor, constant: -12).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(expandedInformation.view)
        expandedInformation.view.topAnchor.constraint(equalTo: darkView.bottomAnchor, constant: 0).isActive = true
        expandedInformation.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        expandedInformation.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedInformation.view.heightAnchor.constraint(equalToConstant: expandedInformation.height).isActive = true
        
        scrollView.addSubview(expandedCost.view)
        expandedCost.view.topAnchor.constraint(equalTo: expandedInformation.view.bottomAnchor).isActive = true
        expandedCost.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        expandedCost.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedCost.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.addSubview(expandedNumber.view)
        expandedNumber.view.topAnchor.constraint(equalTo: expandedCost.view.bottomAnchor).isActive = true
        expandedNumber.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        expandedNumber.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedNumber.view.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        scrollView.addSubview(expandedAmenities.view)
        expandedAmenities.view.topAnchor.constraint(equalTo: expandedNumber.view.bottomAnchor).isActive = true
        expandedAmenities.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        expandedAmenities.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        expandedAmenities.view.heightAnchor.constraint(equalToConstant: expandedAmenities.height).isActive = true
        
        scrollView.addSubview(expandedOptions.view)
        expandedOptions.view.topAnchor.constraint(equalTo: expandedAmenities.view.bottomAnchor, constant: 20).isActive = true
        expandedOptions.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        expandedOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        expandedOptions.view.heightAnchor.constraint(equalToConstant: 240).isActive = true
        expandedOptions.seeAvailability.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        expandedInformation.editInformation.addTarget(self, action: #selector(openInformation), for: .touchUpInside)
        expandedCost.editInformation.addTarget(self, action: #selector(openCost), for: .touchUpInside)
        expandedNumber.editInformation.addTarget(self, action: #selector(openSpots), for: .touchUpInside)
        expandedAmenities.editInformation.addTarget(self, action: #selector(openAmenities), for: .touchUpInside)
        
        height = expandedInformation.height + 100 + 132 + expandedAmenities.height + 750
        scrollView.contentSize = CGSize(width: phoneWidth, height: height)
        
        scrollView.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 76).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 96).isActive = true
        }
        
        gradientContainer.addSubview(gradientLocatingLabel)
        gradientLocatingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        gradientLocatingLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 16).isActive = true
        gradientLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        gradientLocatingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
}

extension HostingExpandedViewController {
    
    @objc func openCalendar() {
        self.editCalendar.setupPreviousAvailability()
        self.navigationController?.pushViewController(editCalendar, animated: true)
        self.lightContentStatusBar()
    }
    
    @objc func openInformation() {
        self.navigationController?.pushViewController(editInformation, animated: true)
        self.lightContentStatusBar()
    }
    
    @objc func openCost() {
        self.navigationController?.pushViewController(editCost, animated: true)
        self.lightContentStatusBar()
    }
    
    @objc func openSpots() {
        self.navigationController?.pushViewController(editSpots, animated: true)
        self.lightContentStatusBar()
    }
    
    @objc func openAmenities() {
        self.navigationController?.pushViewController(editAmenities, animated: true)
        self.lightContentStatusBar()
    }
    
    func checkStatusBar() {
        let translation = scrollView.contentOffset.y
        if translation >= 180 {
            self.delegate?.darkContentStatusBar()
        } else {
            self.lightContentStatusBar()
        }
    }
    
}

extension HostingExpandedViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        UIView.animate(withDuration: animationIn) {
            if translation >= 180 {
                self.gradientContainer.alpha = 1
            } else if translation <= -40.0 - statusHeight {
                self.backButtonPressed()
            } else {
                self.gradientContainer.alpha = 0
                self.lightContentStatusBar()
                self.backButton.tintColor = Theme.WHITE
            }
        }
    }
    
    func lightContentStatusBar() {
        self.statusBarColor = true
        UIView.animate(withDuration: animationIn) {
            self.backButton.tintColor = Theme.WHITE
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func defaultContentStatusBar() {
        self.statusBarColor = false
        UIView.animate(withDuration: animationIn) {
            self.backButton.tintColor = Theme.BLACK
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarColor == true {
            return .lightContent
        } else {
            return .default
        }
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

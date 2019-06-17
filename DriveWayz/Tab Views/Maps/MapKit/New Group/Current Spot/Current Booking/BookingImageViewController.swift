//
//  BookingInfoViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingImageViewController: UIViewController {
    
    var destinationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.STRAWBERRY_PINK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "University Heights Avenue"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "One-Car Driveway"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN_PIGMENT
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var navigationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "locationArrow")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        return button
    }()
    
    var navigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Navigation"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var checkInView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STRAWBERRY_PINK
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var checkInIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "checkInIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
        
        return button
    }()
    
    var checkInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Check In"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var bookingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        let image = UIImage(named: "exampleParking")
        view.image = image
//        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var overviewButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Overview", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var paymentButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Payment", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.alpha = 0.2
        
        return label
    }()
    
    var reviewsButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Reviews", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.alpha = 0.2
        
        return label
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN_PIGMENT
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupNavigation()
        setupCheckIn()
        setupImage()
        setupOptions()
    }
    
    func setupViews() {
        
        self.view.addSubview(destinationIcon)
        destinationIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        destinationIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        destinationIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        destinationIcon.widthAnchor.constraint(equalTo: destinationIcon.heightAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: destinationIcon.rightAnchor, constant: 6).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: destinationIcon.bottomAnchor, constant: 4).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func setupNavigation() {
        
        self.view.addSubview(navigationView)
        navigationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        navigationView.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -18).isActive = true
        navigationView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navigationView.addSubview(navigationLabel)
        navigationLabel.rightAnchor.constraint(equalTo: navigationView.rightAnchor, constant: -16).isActive = true
        navigationLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationLabel.sizeToFit()
        
        navigationView.addSubview(navigationIcon)
        navigationIcon.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 12).isActive = true
        navigationIcon.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navigationIcon.widthAnchor.constraint(equalTo: navigationIcon.heightAnchor).isActive = true
        
    }
    
    func setupCheckIn() {
        
        self.view.addSubview(checkInView)
        checkInView.leftAnchor.constraint(equalTo: navigationView.rightAnchor, constant: 16).isActive = true
        checkInView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        checkInView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24).isActive = true
        checkInView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkInView.addSubview(checkInLabel)
        checkInLabel.rightAnchor.constraint(equalTo: checkInView.rightAnchor, constant: -40).isActive = true
        checkInLabel.centerYAnchor.constraint(equalTo: checkInView.centerYAnchor).isActive = true
        checkInLabel.sizeToFit()
        
        checkInView.addSubview(checkInIcon)
        checkInIcon.leftAnchor.constraint(equalTo: checkInView.leftAnchor, constant: 8).isActive = true
        checkInIcon.centerYAnchor.constraint(equalTo: checkInView.centerYAnchor).isActive = true
        checkInIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkInIcon.widthAnchor.constraint(equalTo: checkInView.heightAnchor).isActive = true
        
    }
    
    func setupImage() {
        
        self.view.addSubview(bookingImageView)
        bookingImageView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 24).isActive = true
        bookingImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        bookingImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        bookingImageView.heightAnchor.constraint(equalTo: bookingImageView.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
    var selectionCenterAnchor: NSLayoutConstraint!
    
    func setupOptions() {
        
        self.view.addSubview(overviewButton)
        overviewButton.topAnchor.constraint(equalTo: bookingImageView.bottomAnchor, constant: 24).isActive = true
        overviewButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        overviewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        overviewButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.topAnchor.constraint(equalTo: bookingImageView.bottomAnchor, constant: 24).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: overviewButton.rightAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        paymentButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        
        self.view.addSubview(reviewsButton)
        reviewsButton.topAnchor.constraint(equalTo: bookingImageView.bottomAnchor, constant: 24).isActive = true
        reviewsButton.leftAnchor.constraint(equalTo: paymentButton.rightAnchor).isActive = true
        reviewsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reviewsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionCenterAnchor = selectionLine.centerXAnchor.constraint(equalTo: overviewButton.centerXAnchor)
            selectionCenterAnchor.isActive = true
        selectionLine.topAnchor.constraint(equalTo: overviewButton.bottomAnchor, constant: 2).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}

//
//  FullDistanceViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class FullDistanceViewController: UIViewController {
    
    var driveTime: Double = 0.0 {
        didSet {
            print(driveTime)
        }
    }
    
    var locationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        
        return view
    }()
    
    var locationShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 3
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var userLocationDot: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PACIFIC_BLUE
        view.layer.cornerRadius = 10
        view.layer.borderColor = Theme.WHITE.cgColor
        view.layer.borderWidth = 3
        view.clipsToBounds = true
        
        return view
    }()
    
    var userShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var parkingSpotIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "parkingSpaceIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var destinationLocationDot: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 10
        view.layer.borderColor = Theme.PURPLE.cgColor
        view.layer.borderWidth = 6
        view.clipsToBounds = true
        
        return view
    }()
    
    var destinationShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var gradientLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.PACIFIC_BLUE, bottomColor: Theme.PURPLE)
        background.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        background.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: -CGFloat.pi/2))
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "parkingSpaceIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "5 min"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var walkingIcon: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "walkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.image = tintedImage
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.05)
        
        return button
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var drivingIcon: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "carIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.image = tintedImage
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    var drivingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var fromTravelLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current Location"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    var toTravelLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Folsom Field"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var middleDots: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let radius: CGFloat = 10
        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = Theme.PURPLE.withAlphaComponent(0.3)
        view1.layer.cornerRadius = radius
        let view2 = UIView()
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.backgroundColor = Theme.PURPLE.withAlphaComponent(0.3)
        view2.layer.cornerRadius = radius
        let view3 = UIView()
        view3.translatesAutoresizingMaskIntoConstraints = false
        view3.backgroundColor = Theme.PURPLE.withAlphaComponent(0.3)
        view3.layer.cornerRadius = radius
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLocation()
        setupDistance()
        setupLabels()
    }
    
    func setupViews() {

        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func setupLocation() {
        
        self.view.addSubview(gradientLine)
        self.view.addSubview(userShadowView)
        self.view.addSubview(userLocationDot)
        self.view.addSubview(parkingSpotIcon)
        self.view.addSubview(destinationShadowView)
        self.view.addSubview(destinationLocationDot)
        
        gradientLine.leftAnchor.constraint(equalTo: userLocationDot.centerXAnchor).isActive = true
        gradientLine.rightAnchor.constraint(equalTo: destinationLocationDot.centerXAnchor).isActive = true
        gradientLine.heightAnchor.constraint(equalToConstant: 6).isActive = true
        gradientLine.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 72).isActive = true
        
        userLocationDot.rightAnchor.constraint(equalTo: parkingSpotIcon.leftAnchor, constant: -72).isActive = true
        userLocationDot.centerYAnchor.constraint(equalTo: gradientLine.centerYAnchor).isActive = true
        userLocationDot.widthAnchor.constraint(equalToConstant: 20).isActive = true
        userLocationDot.heightAnchor.constraint(equalTo: userLocationDot.widthAnchor).isActive = true
        
        userShadowView.topAnchor.constraint(equalTo: userLocationDot.topAnchor).isActive = true
        userShadowView.leftAnchor.constraint(equalTo: userLocationDot.leftAnchor).isActive = true
        userShadowView.rightAnchor.constraint(equalTo: userLocationDot.rightAnchor).isActive = true
        userShadowView.bottomAnchor.constraint(equalTo: userLocationDot.bottomAnchor).isActive = true
        
        parkingSpotIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingSpotIcon.bottomAnchor.constraint(equalTo: userLocationDot.centerYAnchor, constant: 0).isActive = true
        parkingSpotIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        parkingSpotIcon.heightAnchor.constraint(equalTo: parkingSpotIcon.widthAnchor, multiplier: 1.16).isActive = true
        
        destinationLocationDot.leftAnchor.constraint(equalTo: parkingSpotIcon.rightAnchor, constant: 72).isActive = true
        destinationLocationDot.centerYAnchor.constraint(equalTo: userLocationDot.centerYAnchor).isActive = true
        destinationLocationDot.widthAnchor.constraint(equalToConstant: 20).isActive = true
        destinationLocationDot.heightAnchor.constraint(equalTo: destinationLocationDot.widthAnchor).isActive = true
        
        destinationShadowView.topAnchor.constraint(equalTo: destinationLocationDot.topAnchor).isActive = true
        destinationShadowView.leftAnchor.constraint(equalTo: destinationLocationDot.leftAnchor).isActive = true
        destinationShadowView.rightAnchor.constraint(equalTo: destinationLocationDot.rightAnchor).isActive = true
        destinationShadowView.bottomAnchor.constraint(equalTo: destinationLocationDot.bottomAnchor).isActive = true
        
    }
    
    func setupDistance() {
        
        self.view.addSubview(distanceLabel)
        self.view.addSubview(walkingIcon)
        self.view.addSubview(drivingLabel)
        self.view.addSubview(drivingIcon)
        
        distanceLabel.centerXAnchor.constraint(equalTo: destinationLocationDot.centerXAnchor, constant: -32).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: drivingLabel.centerYAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        walkingIcon.centerXAnchor.constraint(equalTo: distanceLabel.centerXAnchor).isActive = true
        walkingIcon.topAnchor.constraint(equalTo: destinationLocationDot.bottomAnchor, constant: 12).isActive = true
        walkingIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        walkingIcon.heightAnchor.constraint(equalTo: walkingIcon.widthAnchor).isActive = true
        
        drivingLabel.centerXAnchor.constraint(equalTo: userLocationDot.centerXAnchor, constant: 32).isActive = true
        drivingLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        drivingLabel.topAnchor.constraint(equalTo: drivingIcon.bottomAnchor, constant: -16).isActive = true
        drivingLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        drivingIcon.centerXAnchor.constraint(equalTo: drivingLabel.centerXAnchor).isActive = true
        drivingIcon.topAnchor.constraint(equalTo: userLocationDot.bottomAnchor, constant: 12).isActive = true
        drivingIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        drivingIcon.heightAnchor.constraint(equalTo: drivingIcon.widthAnchor).isActive = true
        
    }
    
    func setupLabels() {
        
        self.view.addSubview(fromTravelLabel)
        fromTravelLabel.centerXAnchor.constraint(equalTo: userLocationDot.centerXAnchor).isActive = true
        fromTravelLabel.bottomAnchor.constraint(equalTo: userLocationDot.topAnchor, constant: -4).isActive = true
        fromTravelLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        fromTravelLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(toTravelLabel)
        toTravelLabel.centerXAnchor.constraint(equalTo: destinationLocationDot.centerXAnchor).isActive = true
        toTravelLabel.bottomAnchor.constraint(equalTo: destinationLocationDot.topAnchor, constant: -4).isActive = true
        toTravelLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        toTravelLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }



}

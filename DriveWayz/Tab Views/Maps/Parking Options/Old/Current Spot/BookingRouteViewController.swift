//
//  BookingRouteViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingRouteViewController: UIViewController {
    
    var arrivalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Estimated parking arrival - 12:31 pm", for: .normal)
        button.setTitleColor(Theme.GREEN, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var walkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 minute walk to your destination"
        label.textColor = Theme.BLACK.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.2)
        
        return view
    }()
    
    var userIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.borderColor = Theme.WHITE.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 9
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var parkingIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.SALMON.cgColor
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 9
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var destinationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.backgroundColor = Theme.WHITE
        
        return button
    }()
    
    var dottedLine: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "circleLine")
        view.image = image
        view.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        view.tintColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var gradientLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 6, height: 84)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [Theme.WARM_2_LIGHT.withAlphaComponent(0.8).cgColor,
                           Theme.SALMON.cgColor]
        view.layer.addSublayer(gradient)
        
        return view
    }()
    
    var departLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Depart"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    var timeArriveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ETA\n12:15"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 2
        
        return label
    }()
    
    var destinationArriveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Arrive"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 2
        
        return label
    }()
    
    var driveTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1h 30m drive"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var walkTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8m walk"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var vehicleIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "vehicle")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkingIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "walkingIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var userLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current location"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var parkingLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4th Avenue, Barcelona"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var destinationLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
        setupRoutes()
        setupTimes()
        setupLocations()
    }
    
    func setupViews() {
        
        self.view.addSubview(arrivalButton)
        arrivalButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        arrivalButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        arrivalButton.sizeToFit()
        
        self.view.addSubview(walkLabel)
        walkLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        walkLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        walkLabel.topAnchor.constraint(equalTo: arrivalButton.bottomAnchor, constant: 0).isActive = true
        walkLabel.sizeToFit()
        
        self.view.addSubview(line)
        line.topAnchor.constraint(equalTo: walkLabel.bottomAnchor, constant: 12).isActive = true
        line.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupRoutes() {
        
        self.view.addSubview(dottedLine)
        self.view.addSubview(gradientLine)
        
        self.view.addSubview(userIcon)
        userIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 84).isActive = true
        userIcon.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 32).isActive = true
        userIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        userIcon.widthAnchor.constraint(equalTo: userIcon.heightAnchor).isActive = true
        
        self.view.addSubview(parkingIcon)
        parkingIcon.centerXAnchor.constraint(equalTo: userIcon.centerXAnchor).isActive = true
        parkingIcon.topAnchor.constraint(equalTo: userIcon.bottomAnchor, constant: 78).isActive = true
        parkingIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        parkingIcon.widthAnchor.constraint(equalTo: parkingIcon.heightAnchor).isActive = true
        
        self.view.addSubview(destinationIcon)
        destinationIcon.centerXAnchor.constraint(equalTo: userIcon.centerXAnchor).isActive = true
        destinationIcon.topAnchor.constraint(equalTo: parkingIcon.bottomAnchor, constant: 82).isActive = true
        destinationIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        destinationIcon.widthAnchor.constraint(equalTo: destinationIcon.heightAnchor).isActive = true
        
        dottedLine.topAnchor.constraint(equalTo: parkingIcon.bottomAnchor, constant: 6).isActive = true
        dottedLine.bottomAnchor.constraint(equalTo: destinationIcon.topAnchor, constant: 14).isActive = true
        dottedLine.centerXAnchor.constraint(equalTo: userIcon.centerXAnchor, constant: 2).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        gradientLine.topAnchor.constraint(equalTo: userIcon.bottomAnchor, constant: -3).isActive = true
        gradientLine.bottomAnchor.constraint(equalTo: parkingIcon.topAnchor, constant: 3).isActive = true
        gradientLine.centerXAnchor.constraint(equalTo: userIcon.centerXAnchor).isActive = true
        gradientLine.widthAnchor.constraint(equalToConstant: 6).isActive = true
        
    }
    
    func setupTimes() {
        
        self.view.addSubview(departLabel)
        departLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        departLabel.centerYAnchor.constraint(equalTo: userIcon.centerYAnchor).isActive = true
        departLabel.sizeToFit()
        
        self.view.addSubview(timeArriveLabel)
        timeArriveLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        timeArriveLabel.centerYAnchor.constraint(equalTo: parkingIcon.centerYAnchor).isActive = true
        timeArriveLabel.sizeToFit()
        
        self.view.addSubview(destinationArriveLabel)
        destinationArriveLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        destinationArriveLabel.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor).isActive = true
        destinationArriveLabel.sizeToFit()
        
        self.view.addSubview(driveTimeLabel)
        driveTimeLabel.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 16).isActive = true
        driveTimeLabel.centerYAnchor.constraint(equalTo: gradientLine.centerYAnchor).isActive = true
        driveTimeLabel.sizeToFit()
        
        self.view.addSubview(walkTimeLabel)
        walkTimeLabel.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 16).isActive = true
        walkTimeLabel.centerYAnchor.constraint(equalTo: dottedLine.centerYAnchor).isActive = true
        walkTimeLabel.sizeToFit()
        
        self.view.addSubview(vehicleIcon)
        vehicleIcon.rightAnchor.constraint(equalTo: userIcon.centerXAnchor, constant: -24).isActive = true
        vehicleIcon.centerYAnchor.constraint(equalTo: driveTimeLabel.centerYAnchor).isActive = true
        vehicleIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        vehicleIcon.widthAnchor.constraint(equalTo: vehicleIcon.heightAnchor).isActive = true
        
        self.view.addSubview(walkingIcon)
        walkingIcon.rightAnchor.constraint(equalTo: userIcon.centerXAnchor, constant: -24).isActive = true
        walkingIcon.centerYAnchor.constraint(equalTo: walkTimeLabel.centerYAnchor).isActive = true
        walkingIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        walkingIcon.widthAnchor.constraint(equalTo: walkingIcon.heightAnchor).isActive = true
        
    }
    
    func setupLocations() {
        
        self.view.addSubview(userLocationLabel)
        userLocationLabel.leftAnchor.constraint(equalTo: driveTimeLabel.leftAnchor).isActive = true
        userLocationLabel.centerYAnchor.constraint(equalTo: userIcon.centerYAnchor).isActive = true
        userLocationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userLocationLabel.sizeToFit()
        
        self.view.addSubview(parkingLocationLabel)
        parkingLocationLabel.leftAnchor.constraint(equalTo: driveTimeLabel.leftAnchor).isActive = true
        parkingLocationLabel.centerYAnchor.constraint(equalTo: parkingIcon.centerYAnchor).isActive = true
        parkingLocationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLocationLabel.sizeToFit()
        
        self.view.addSubview(destinationLocationLabel)
        destinationLocationLabel.leftAnchor.constraint(equalTo: driveTimeLabel.leftAnchor).isActive = true
        destinationLocationLabel.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor).isActive = true
        destinationLocationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        destinationLocationLabel.sizeToFit()
        
    }

}

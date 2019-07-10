//
//  UpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

protocol handleUpcomingConrollers {
    func closeRecentController()
    func hostingPreviousPressed(booking: Bookings, region: MGLCoordinateBounds, route: MGLPolyline, parking: CLLocationCoordinate2D, destination: CLLocationCoordinate2D)
}

class UserUpcomingViewController: UIViewController, handleUpcomingConrollers {
    
    var delegate: moveControllers?
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Bookings"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    lazy var parkingTableController: UpcomingViewController = {
        let controller = UpcomingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var recentController: UserRecentViewController = {
        let controller = UserRecentViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var recentTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        self.view.addSubview(parkingTableController.view)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        parkingTableController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingTableController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        parkingTableController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingTableController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(recentController.view)
        recentTopAnchor = recentController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            recentTopAnchor.isActive = true
        recentController.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        recentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        recentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        recentController.backButton.addTarget(self, action: #selector(closeRecentController), for: .touchUpInside)
        
    }
    
    @objc func closeRecentController() {
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.recentTopAnchor.constant = phoneHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func hostingPreviousPressed(booking: Bookings, region: MGLCoordinateBounds, route: MGLPolyline, parking: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.recentController.setData(booking: booking, region: region, route: route, parking: parking, destination: destination)
        self.recentTopAnchor.constant = -statusHeight
        self.delegate?.defaultContentStatusBar()
        self.delegate?.dismissActiveController()
        UIView.animate(withDuration: animationOut) {
            self.recentController.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            self.backButton.alpha = 0
        }
    }
    
}

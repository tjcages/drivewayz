//
//  VehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/17/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handleNewVehicle {
    func bringNewVehicle()
    func hideNewVehicle()
}

class VehicleViewController: UIViewController, handleNewVehicle {

    var delegate: controlsAccountOptions?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Vehicles"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH0
        
        return label
    }()
    
    lazy var userVehicleController: UserVehicleViewController = {
        let controller = UserVehicleViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Vehicle"
//        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        
        self.view.addSubview(userVehicleController.view)
        self.view.addSubview(gradientContainer)
        userVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userVehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userVehicleController.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        userVehicleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
     
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
            let background = CAGradientLayer().purpleBlueColor()
            background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 160)
            background.zPosition = -10
            gradientContainer.layer.addSublayer(background)
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
            let background = CAGradientLayer().purpleBlueColor()
            background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 180)
            background.zPosition = -10
            gradientContainer.layer.addSublayer(background)
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        switch device {
        case .iphone8:
            mainLabel.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 96).isActive = true
        case .iphoneX:
            mainLabel.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 120).isActive = true
        }
        
    }
    
    func bringNewVehicle() {
//        self.delegate?.hideVehicleController()
    }
    
    func hideNewVehicle() {
        self.delegate?.bringVehicleController()
    }
    

}

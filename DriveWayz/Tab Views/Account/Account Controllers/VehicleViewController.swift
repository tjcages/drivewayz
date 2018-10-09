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
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var userVehicleController: UserVehicleViewController = {
        let controller = UserVehicleViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Vehicle"
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 40).isActive = true
        container.heightAnchor.constraint(equalToConstant: self.view.frame.height - 160).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
        self.view.addSubview(userVehicleController.view)
        userVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userVehicleController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        userVehicleController.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 30).isActive = true
        userVehicleController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.delegate?.hideVehicleController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.closeAccountView()
        }
    }
    
    func bringNewVehicle() {
        self.delegate?.hideVehicleController()
        self.delegate?.bringNewVehicleController(vehicleStatus: .noVehicle)
    }
    
    func hideNewVehicle() {
        self.delegate?.hideNewVehicleController()
        self.delegate?.bringVehicleController()
    }
    

}

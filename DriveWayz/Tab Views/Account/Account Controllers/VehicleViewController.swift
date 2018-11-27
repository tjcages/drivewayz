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
        
        return view
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
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(userVehicleController.view)
        userVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userVehicleController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        userVehicleController.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 30).isActive = true
        userVehicleController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
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

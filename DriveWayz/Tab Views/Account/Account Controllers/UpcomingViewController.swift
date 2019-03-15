//
//  UpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        //        button.setTitle("Show all", for: .normal)
        button.setTitle("You have not had any bookings yet", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var parkingTableController: ParkingTableViewController = {
        let controller = ParkingTableViewController()
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
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
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        container.addSubview(parkingTableController.view)
        parkingTableController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        parkingTableController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        parkingTableController.view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        parkingTableController.view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        container.addSubview(showMoreButton)
        showMoreButton.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -120).isActive = true
        showMoreButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        showMoreButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        showMoreButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}

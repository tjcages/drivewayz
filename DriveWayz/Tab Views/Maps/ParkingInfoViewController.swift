//
//  ParkingInfoViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ParkingInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.OFF_WHITE
        self.navigationController?.navigationBar.isHidden = true
        
        setupViews()
    }
    
    var parkingViewTopAnchor: NSLayoutConstraint!
    var titleLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(parkingView)
        parkingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        parkingViewTopAnchor = parkingView.topAnchor.constraint(equalTo: view.topAnchor)
        parkingViewTopAnchor.isActive = true
        parkingView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        parkingView.addSubview(labelTitle)
        titleLeftAnchor = labelTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        titleLeftAnchor.isActive = true
        labelTitle.topAnchor.constraint(equalTo: parkingView.topAnchor, constant: 20).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        parkingView.addSubview(labelDistance)
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 16).isActive = true
        labelDistance.topAnchor.constraint(equalTo: labelTitle.bottomAnchor).isActive = true
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelDistance.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        parkingView.addSubview(labelCost)
        labelCost.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 16).isActive = true
        labelCost.topAnchor.constraint(equalTo: labelDistance.bottomAnchor).isActive = true
        labelCost.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelCost.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(labelDescription)
        labelDescription.leftAnchor.constraint(equalTo: parkingView.leftAnchor, constant: 20).isActive = true
        labelDescription.topAnchor.constraint(equalTo: parkingView.bottomAnchor, constant: 20).isActive = true
        labelDescription.rightAnchor.constraint(equalTo: parkingView.rightAnchor, constant: -20).isActive = true
        labelDescription.text = "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\""
        labelDescription.sizeToFit()
        
    }
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.OFF_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDistance: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelCost: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}

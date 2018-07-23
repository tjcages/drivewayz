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

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(parkingView)
        parkingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        parkingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        parkingView.addSubview(labelTitle)
        labelTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        labelTitle.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        parkingView.addSubview(labelCost)
        labelCost.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 16).isActive = true
        labelCost.bottomAnchor.constraint(equalTo: labelTitle.topAnchor).isActive = true
        labelCost.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelCost.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        parkingView.addSubview(labelDistance)
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 16).isActive = true
        labelDistance.bottomAnchor.constraint(equalTo: labelCost.topAnchor).isActive = true
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelDistance.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDistance: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelCost: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let labelDescription: UILabel = {
//        let label = UILabel()
//        label.text = "Description"
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 20)
//        label.textColor = Theme.PRIMARY_DARK_COLOR
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
}

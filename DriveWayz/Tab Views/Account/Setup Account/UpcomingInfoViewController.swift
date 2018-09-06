//
//  UpcomingInfoViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/5/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class UpcomingInfoViewController: UIViewController {

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

    let labelCost: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var stars: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 15
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.settings.emptyBorderColor = Theme.DARK_GRAY
        view.settings.filledBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    func setData(cityAddress: String, parkingCost: String, formattedAddress: String, rating: Double) {
        labelTitle.text = cityAddress
        labelCost.text = parkingCost
        stars.rating = rating
    }

    func setupViews() {
        
        view.addSubview(parkingView)
        parkingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        parkingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        parkingView.addSubview(labelTitle)
        labelTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        labelTitle.topAnchor.constraint(equalTo: parkingView.topAnchor, constant: 10).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        parkingView.addSubview(line)
        line.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 0).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.widthAnchor.constraint(equalTo: parkingView.widthAnchor, constant: -40).isActive = true
        line.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
        
        parkingView.addSubview(labelCost)
        labelCost.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 5).isActive = true
        labelCost.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10).isActive = true
        labelCost.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelCost.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        parkingView.addSubview(stars)
        stars.leftAnchor.constraint(greaterThanOrEqualTo: parkingView.centerXAnchor, constant: 20).isActive = true
        stars.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        stars.centerYAnchor.constraint(equalTo: labelCost.centerYAnchor).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }

}

//
//  ParkingInfoViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class ParkingInfoViewController: UIViewController {
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelTime: UILabel = {
        let label = UILabel()
        label.text = "Available until 5:00 pm"
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = Fonts.SSPSemiBoldH2
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDistance: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelCost: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = Fonts.SSPSemiBoldH3
        label.textColor = Theme.SEA_BLUE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 17.5
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.SEA_BLUE
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        view.settings.filledBorderColor = Theme.SEA_BLUE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setData(cityAddress: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, parkingDistance: String, rating: Double) {
        let address = cityAddress.dropFirst()
        labelTitle.text = String(address)
        labelCost.text = parkingCost
        labelDistance.text = "\(parkingDistance) miles away"
        stars.rating = rating
    }
    
    func setupViews() {
        
        view.addSubview(parkingView)
        parkingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        parkingView.addSubview(labelTime)
        labelTime.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        labelTime.topAnchor.constraint(equalTo: parkingView.topAnchor, constant: 20).isActive = true
        labelTime.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        labelTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        parkingView.addSubview(labelTitle)
        labelTitle.leftAnchor.constraint(equalTo: labelTime.leftAnchor).isActive = true
        labelTitle.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 10).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        parkingView.addSubview(line)
        line.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.widthAnchor.constraint(equalTo: parkingView.widthAnchor, constant: -40).isActive = true
        line.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
        
        parkingView.addSubview(labelCost)
        labelCost.leftAnchor.constraint(equalTo: labelTitle.leftAnchor).isActive = true
        labelCost.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 15).isActive = true
        labelCost.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelCost.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        parkingView.addSubview(labelDistance)
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 2).isActive = true
        labelDistance.topAnchor.constraint(equalTo: labelCost.bottomAnchor, constant: 5).isActive = true
        labelDistance.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelDistance.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        parkingView.addSubview(stars)
        stars.leftAnchor.constraint(greaterThanOrEqualTo: parkingView.centerXAnchor, constant: 0).isActive = true
        stars.centerYAnchor.constraint(equalTo: labelCost.centerYAnchor).isActive = true
        stars.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: labelDistance.bottomAnchor, constant: 20).isActive = true
        
    }
    
}

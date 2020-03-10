//
//  ExpandedCostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedCostViewController: UIViewController {

    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "HOURLY RATE"
        
        return label
    }()
    
    var hourlyRate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$2.40 per hour"
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setData(hosting: ParkingSpots) {
        if let parkingCost = hosting.parkingCost {
            self.hourlyRate.text = String(format:"$%.02f", parkingCost)
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(residentialLabel)
        residentialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        residentialLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        residentialLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        residentialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(editInformation)
        editInformation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(hourlyRate)
        hourlyRate.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 4).isActive = true
        hourlyRate.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        hourlyRate.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        hourlyRate.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: hourlyRate.bottomAnchor, constant: 20).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }

}

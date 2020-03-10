//
//  ProgressExpandedView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProgressExpandedView: UIViewController {
    
    let mainText: [String] = ["Start a new listing", "Booking info", "Maximize bookings", "Driver booking", "Get ready to host"]
    let subText: [String] = ["Tell us where the spot is located and \nthe type of parking.", "Show drivers exactly where to park \nafter booking.", "Customize when you want the spot \navailable or unavailable.", "Determine the hourly price drivers will \npay when booking your spot.", "Promote your spot and agree to host \npolicies to confirm your listing."]
    
    var selectedIndex: Int = 0 {
        didSet {
            mainLabel.text = mainText[selectedIndex]
            subLabel.text = subText[selectedIndex]
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start a new listing"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tell us where the spot is located and \nthe type of parking."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
    
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(mainButton)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
        mainButton.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 124, height: 45)
        
    }

}

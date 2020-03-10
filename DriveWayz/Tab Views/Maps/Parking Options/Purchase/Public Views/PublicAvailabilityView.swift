//
//  PublicAvailabilityView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/10/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class PublicAvailabilityView: UIView {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Predicted availability"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We are currently working to implement payment processing with ACE parking."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 4
        
        return label
    }()
    
    var availability: BookingAvailabilityView = {
        let view = BookingAvailabilityView()
        view.alpha = 1
        
        return view
    }()
    
    var busyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Busy"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()

    var whyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("How is availability determined?", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews() {
     
        addSubview(mainLabel)
        addSubview(informationLabel)
        addSubview(availability)
        addSubview(busyLabel)
        addSubview(whyButton)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: availability.leftAnchor, constant: -32).isActive = true
        informationLabel.sizeToFit()
        
        availability.anchor(top: mainLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 52, height: 14)
        
        busyLabel.topAnchor.constraint(equalTo: availability.bottomAnchor, constant: 4).isActive = true
        busyLabel.rightAnchor.constraint(equalTo: availability.rightAnchor).isActive = true
        busyLabel.sizeToFit()
        
        whyButton.anchor(top: informationLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        whyButton.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  BookingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/9/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class BookingView: UIView {
        
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Public"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var walkIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "walk_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$3.50/hour"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()

    var aceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE_LIGHT.withAlphaComponent(0.6)
        button.setTitle("ACE", for: .normal)
        button.setTitleColor(Theme.BLUE_DARK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var availability = BookingAvailabilityView()

    var availabilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Busy"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = false
        
        setupViews()
    }
    
    func setupViews() {
  
        addSubview(mainLabel)
        addSubview(walkIcon)
        addSubview(subLabel)
        addSubview(aceButton)
        
        mainLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainLabel.sizeToFit()
        
        walkIcon.centerYAnchor.constraint(equalTo: subLabel.centerYAnchor).isActive = true
        walkIcon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        walkIcon.heightAnchor.constraint(equalTo: walkIcon.widthAnchor).isActive = true
        walkIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        subLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        subLabel.leftAnchor.constraint(equalTo: walkIcon.rightAnchor, constant: 4).isActive = true
        subLabel.sizeToFit()
        
        aceButton.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: -4).isActive = true
        aceButton.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 8).isActive = true
        aceButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aceButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        addSubview(costLabel)
        addSubview(availability)
        addSubview(availabilityLabel)
        
        costLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        costLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        costLabel.sizeToFit()
        
        availabilityLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        availabilityLabel.rightAnchor.constraint(equalTo: availability.leftAnchor, constant: -8).isActive = true
        availabilityLabel.sizeToFit()
        
        availability.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 52, height: 14)
        availability.centerYAnchor.constraint(equalTo: availabilityLabel.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

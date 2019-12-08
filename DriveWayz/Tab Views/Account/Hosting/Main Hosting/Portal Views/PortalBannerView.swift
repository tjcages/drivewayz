//
//  PortalBannerView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PortalBannerView: UIView {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Currently booked"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:15am • 2:45pm"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.BLUE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(subLabel)
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: subLabel.leftAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

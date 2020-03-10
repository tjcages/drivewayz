//
//  QuickParkingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickParkingView: UIView {
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.text = "Current location"
        
        return label
    }()
    
    var expandButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.2
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(parkingLabel)
        addSubview(expandButton)
        
        parkingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        parkingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        parkingLabel.sizeToFit()
        
        expandButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        expandButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

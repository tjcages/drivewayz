//
//  QuickDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickDurationView: UIView {
    
    var darkContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var walkingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "walkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "vehicle");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.text = "945 Diamond St"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH6
        label.text = "Walk to"
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var minLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MIN"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
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
        
        addSubview(darkContainer)
//        addSubview(walkingIcon)
//        addSubview(carIcon)
        addSubview(parkingLabel)
        addSubview(subLabel)
        addSubview(distanceLabel)
        addSubview(minLabel)
        addSubview(expandButton)
        
        darkContainer.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        darkContainer.widthAnchor.constraint(equalTo: darkContainer.heightAnchor).isActive = true
        
//        walkingIcon.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
//        walkingIcon.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
//        walkingIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        walkingIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        carIcon.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
//        carIcon.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
//        carIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        carIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        parkingLabel.leftAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: 12).isActive = true
        parkingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        parkingLabel.sizeToFit()
        
        subLabel.leftAnchor.constraint(equalTo: darkContainer.rightAnchor, constant: 12).isActive = true
        subLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        subLabel.sizeToFit()
        
        distanceLabel.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        distanceLabel.sizeToFit()
        
        minLabel.centerXAnchor.constraint(equalTo: darkContainer.centerXAnchor).isActive = true
        minLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        minLabel.sizeToFit()
        
        expandButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        expandButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

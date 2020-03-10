//
//  CurrentParkingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentParkingView: UIView {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "photoTutorial2")
        view.image = image
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var profileIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookingProfile")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Special Instructions"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var instructionsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Directly off a major road in Point Loma! From this location…"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        
        return label
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var spotIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseArrive")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Spot Number"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var spotText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "#10"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var line2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var gateIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseLock")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var gateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gate Code"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var gateText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2345"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var parkInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.6)
        button.layer.cornerRadius = 10
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.setTitle("Park within the blue square", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 170)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(parkInfoButton)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 172)
        
        parkInfoButton.anchor(top: imageView.topAnchor, left: imageView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 188, height: 20)
        
        addSubview(profileIcon)
        addSubview(instructionsLabel)
        addSubview(instructionsText)
        addSubview(moreButton)
        
        profileIcon.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        
        instructionsLabel.leftAnchor.constraint(equalTo: profileIcon.rightAnchor, constant: 20).isActive = true
        instructionsLabel.centerYAnchor.constraint(equalTo: profileIcon.centerYAnchor).isActive = true
        instructionsLabel.sizeToFit()
        
        instructionsText.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 4).isActive = true
        instructionsText.leftAnchor.constraint(equalTo: instructionsLabel.leftAnchor).isActive = true
        instructionsText.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        instructionsText.sizeToFit()
        
        moreButton.topAnchor.constraint(equalTo: instructionsText.bottomAnchor, constant: 8).isActive = true
        moreButton.leftAnchor.constraint(equalTo: instructionsLabel.leftAnchor).isActive = true
        moreButton.sizeToFit()
        
        addSubview(line)
        line.anchor(top: moreButton.bottomAnchor, left: instructionsLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(spotIcon)
        addSubview(spotLabel)
        addSubview(spotText)
        
        spotIcon.anchor(top: line.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        
        spotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 20).isActive = true
        spotLabel.centerYAnchor.constraint(equalTo: spotIcon.centerYAnchor).isActive = true
        spotLabel.sizeToFit()
        
        spotText.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        spotText.centerYAnchor.constraint(equalTo: spotIcon.centerYAnchor).isActive = true
        spotText.sizeToFit()
        
        addSubview(line2)
        line2.anchor(top: spotIcon.bottomAnchor, left: instructionsLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(gateIcon)
        addSubview(gateLabel)
        addSubview(gateText)
        
        gateIcon.anchor(top: line2.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        
        gateLabel.leftAnchor.constraint(equalTo: gateIcon.rightAnchor, constant: 20).isActive = true
        gateLabel.centerYAnchor.constraint(equalTo: gateIcon.centerYAnchor).isActive = true
        gateLabel.sizeToFit()
        
        gateText.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        gateText.centerYAnchor.constraint(equalTo: gateIcon.centerYAnchor).isActive = true
        gateText.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

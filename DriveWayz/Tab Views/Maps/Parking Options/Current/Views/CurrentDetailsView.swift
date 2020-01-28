//
//  CurrentDetailsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentDetailsView: UIView {
    
    var delegate: CurrentViewDelegate?
    
//    var secondaryType: String = "driveway" {
//        didSet {
//            if secondaryType == "driveway" {
//                let image = UIImage(named: "Residential Home Driveway")
//                self.spotIcon.image = image
//            } else if secondaryType == "parking lot" {
//                let image = UIImage(named: "Parking Lot")
//                self.spotIcon.image = image
//            } else if secondaryType == "apartment" {
//                let image = UIImage(named: "Apartment Parking")
//                self.spotIcon.image = image
//            } else if secondaryType == "alley" {
//                let image = UIImage(named: "Alley Parking")
//                self.spotIcon.image = image
//            } else if secondaryType == "garage" {
//                let image = UIImage(named: "Parking Garage")
//                self.spotIcon.image = image
//            } else if secondaryType == "gated spot" {
//                let image = UIImage(named: "Gated Spot")
//                self.spotIcon.image = image
//            } else if secondaryType == "street spot" {
//                let image = UIImage(named: "Street Parking")
//                self.spotIcon.image = image
//            } else if secondaryType == "underground spot" {
//                let image = UIImage(named: "UnderGround Parking")
//                self.spotIcon.image = image
//            } else if secondaryType == "condo" {
//                let image = UIImage(named: "Residential Home Driveway")
//                self.spotIcon.image = image
//            } else if secondaryType == "circular" {
//                let image = UIImage(named: "Other Parking")
//                self.spotIcon.image = image
//            }
//        }
//    }
    
    var banner: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var bannerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var bannerSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:15am - 3:45pm"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var slideLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 29
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        
        return view
    }()

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shared"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apartment parking"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()
    
    var detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.layer.cornerRadius = 4
        button.setTitle("Details", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        
        return button
    }()
    
    var extendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = lineColor.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Extend time", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return button
    }()
    
    var issueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = lineColor.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Report issue", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return button
    }()
    
    var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        isHidden = true
        
        setupViews()
        setupDetails()
    }
    
    func setupViews() {
        
        addSubview(banner)
        banner.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 56)
        
        addSubview(bannerLabel)
        addSubview(bannerSubLabel)
        
        bannerLabel.centerYAnchor.constraint(equalTo: banner.centerYAnchor).isActive = true
        bannerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        bannerLabel.sizeToFit()
        
        bannerSubLabel.centerYAnchor.constraint(equalTo: banner.centerYAnchor).isActive = true
        bannerSubLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        bannerSubLabel.sizeToFit()
        
        addSubview(slideLine)
        slideLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        slideLine.anchor(top: banner.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 4)
        
    }
    
    func setupDetails() {
        
        addSubview(spotIcon)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(informationIcon)
        
        spotIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        spotIcon.topAnchor.constraint(equalTo: slideLine.bottomAnchor, constant: 8).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 58).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        mainLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
        informationIcon.anchor(top: nil, left: subLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        informationIcon.centerYAnchor.constraint(equalTo: subLabel.centerYAnchor).isActive = true

        addSubview(detailsButton)
        detailsButton.centerYAnchor.constraint(equalTo: spotIcon.centerYAnchor).isActive = true
        detailsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        detailsButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        detailsButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        addSubview(extendButton)
        addSubview(issueButton)
        
        extendButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 50)
        
        issueButton.anchor(top: nil, left: centerXAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 50)
        
        addSubview(spacer)
        spacer.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

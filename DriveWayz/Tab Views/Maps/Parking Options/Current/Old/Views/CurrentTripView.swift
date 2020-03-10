//
//  CurrentTripView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentTripView: UIView {
    
    var delegate: CurrentViewDelegate?
    
    var tripLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your trip"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "sharingIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        clipsToBounds = true
        
        setupViews()
        setupDrive()
        setupPark()
        setupWalk()
        setupArrive()
        
        showLess()
    }
    
    func setupViews() {
        
        addSubview(tripLabel)
        tripLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        tripLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        tripLabel.sizeToFit()
        
        addSubview(shareButton)
        shareButton.centerYAnchor.constraint(equalTo: tripLabel.centerYAnchor).isActive = true
        shareButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor).isActive = true
        
    }
    
    var driveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "purchaseCar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var driveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drive to Shared Space"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var driveSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "From Current Location"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var driveTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var driveTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15 min drive"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var driveNavigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseNavigation")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var driveNavigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start Navigation"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var dottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.LINE_GRAY
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    func setupDrive() {
        
        addSubview(driveButton)
        addSubview(driveLabel)
        addSubview(driveSubLabel)
        
        driveLabel.topAnchor.constraint(equalTo: tripLabel.bottomAnchor, constant: 20).isActive = true
        driveLabel.leftAnchor.constraint(equalTo: driveButton.rightAnchor, constant: 20).isActive = true
        driveLabel.sizeToFit()
        
        driveSubLabel.topAnchor.constraint(equalTo: driveLabel.bottomAnchor).isActive = true
        driveSubLabel.leftAnchor.constraint(equalTo: driveButton.rightAnchor, constant: 20).isActive = true
        driveSubLabel.sizeToFit()
        
        driveButton.centerYAnchor.constraint(equalTo: driveLabel.bottomAnchor).isActive = true
        driveButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        driveButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        driveButton.widthAnchor.constraint(equalTo: driveButton.heightAnchor).isActive = true
        
        addSubview(driveTimeButton)
        addSubview(driveTimeLabel)
        
        driveTimeButton.topAnchor.constraint(equalTo: driveSubLabel.bottomAnchor, constant: 20).isActive = true
        driveTimeButton.leftAnchor.constraint(equalTo: driveLabel.leftAnchor).isActive = true
        driveTimeButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        driveTimeButton.widthAnchor.constraint(equalTo: driveTimeButton.heightAnchor).isActive = true
        
        driveTimeLabel.leftAnchor.constraint(equalTo: driveTimeButton.rightAnchor, constant: 20).isActive = true
        driveTimeLabel.centerYAnchor.constraint(equalTo: driveTimeButton.centerYAnchor).isActive = true
        driveTimeLabel.sizeToFit()
        
        let line = Line()
        addSubview(line)
        line.anchor(top: driveTimeLabel.bottomAnchor, left: driveLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(driveNavigationButton)
        addSubview(driveNavigationLabel)
        
        driveNavigationButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        driveNavigationButton.leftAnchor.constraint(equalTo: driveLabel.leftAnchor).isActive = true
        driveNavigationButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        driveNavigationButton.widthAnchor.constraint(equalTo: driveNavigationButton.heightAnchor).isActive = true
        
        driveNavigationLabel.leftAnchor.constraint(equalTo: driveNavigationButton.rightAnchor, constant: 20).isActive = true
        driveNavigationLabel.centerYAnchor.constraint(equalTo: driveNavigationButton.centerYAnchor).isActive = true
        driveNavigationLabel.sizeToFit()
        
        let line2 = Line()
        addSubview(line2)
        line2.anchor(top: driveNavigationLabel.bottomAnchor, left: driveLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(dottedLine)
        dottedLine.centerXAnchor.constraint(equalTo: driveButton.centerXAnchor).isActive = true
        dottedLine.topAnchor.constraint(equalTo: driveButton.bottomAnchor, constant: 8).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 6).isActive = true
        dottedLine.heightAnchor.constraint(equalToConstant: 122).isActive = true
        
    }
    
    var parkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "purchaseHome")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var parkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Park in Shared Space"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var parkSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "945 Dixie Drive"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var parkTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseCar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var parkTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "License Plate: 312-ZFA"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var parkNavigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseCheck")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var parkNavigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Check in"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var dottedParkLine: UIImageView = {
        let image = UIImage(named: "dottedLine")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.LINE_GRAY
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    func setupPark() {
        
        addSubview(parkButton)
        addSubview(parkLabel)
        addSubview(parkSubLabel)
        
        parkLabel.topAnchor.constraint(equalTo: dottedLine.bottomAnchor, constant: 8).isActive = true
        parkLabel.leftAnchor.constraint(equalTo: parkButton.rightAnchor, constant: 20).isActive = true
        parkLabel.sizeToFit()
        
        parkSubLabel.topAnchor.constraint(equalTo: parkLabel.bottomAnchor).isActive = true
        parkSubLabel.leftAnchor.constraint(equalTo: parkButton.rightAnchor, constant: 20).isActive = true
        parkSubLabel.sizeToFit()
        
        parkButton.centerYAnchor.constraint(equalTo: parkLabel.bottomAnchor).isActive = true
        parkButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        parkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        parkButton.widthAnchor.constraint(equalTo: parkButton.heightAnchor).isActive = true
        
        addSubview(parkTimeButton)
        addSubview(parkTimeLabel)
        
        parkTimeButton.topAnchor.constraint(equalTo: parkSubLabel.bottomAnchor, constant: 20).isActive = true
        parkTimeButton.leftAnchor.constraint(equalTo: parkLabel.leftAnchor).isActive = true
        parkTimeButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        parkTimeButton.widthAnchor.constraint(equalTo: parkTimeButton.heightAnchor).isActive = true
        
        parkTimeLabel.leftAnchor.constraint(equalTo: parkTimeButton.rightAnchor, constant: 20).isActive = true
        parkTimeLabel.centerYAnchor.constraint(equalTo: parkTimeButton.centerYAnchor).isActive = true
        parkTimeLabel.sizeToFit()
        
        let line = Line()
        addSubview(line)
        line.anchor(top: parkTimeLabel.bottomAnchor, left: parkLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(parkNavigationButton)
        addSubview(parkNavigationLabel)
        
        parkNavigationButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        parkNavigationButton.leftAnchor.constraint(equalTo: parkLabel.leftAnchor).isActive = true
        parkNavigationButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        parkNavigationButton.widthAnchor.constraint(equalTo: parkNavigationButton.heightAnchor).isActive = true
        
        parkNavigationLabel.leftAnchor.constraint(equalTo: parkNavigationButton.rightAnchor, constant: 20).isActive = true
        parkNavigationLabel.centerYAnchor.constraint(equalTo: parkNavigationButton.centerYAnchor).isActive = true
        parkNavigationLabel.sizeToFit()
        
        let line2 = Line()
        addSubview(line2)
        line2.anchor(top: parkNavigationLabel.bottomAnchor, left: parkLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(dottedParkLine)
        dottedParkLine.centerXAnchor.constraint(equalTo: parkButton.centerXAnchor).isActive = true
        dottedParkLine.topAnchor.constraint(equalTo: parkButton.bottomAnchor, constant: 8).isActive = true
        dottedParkLine.widthAnchor.constraint(equalToConstant: 6).isActive = true
        dottedParkLine.heightAnchor.constraint(equalToConstant: 122).isActive = true
        
    }
    
    var walkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "purchaseWalk")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Walk to Mission Bay"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var walkSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "From Shared Space"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var walkTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var walkTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8 min walk"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var walkNavigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseNavigation")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var walkNavigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start Navigation"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var dottedWalkLine: UIImageView = {
        let image = UIImage(named: "dottedLine")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.LINE_GRAY
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    func setupWalk() {
        
        addSubview(walkButton)
        addSubview(walkLabel)
        addSubview(walkSubLabel)
        
        walkLabel.topAnchor.constraint(equalTo: dottedParkLine.bottomAnchor, constant: 8).isActive = true
        walkLabel.leftAnchor.constraint(equalTo: walkButton.rightAnchor, constant: 20).isActive = true
        walkLabel.sizeToFit()
        
        walkSubLabel.topAnchor.constraint(equalTo: walkLabel.bottomAnchor).isActive = true
        walkSubLabel.leftAnchor.constraint(equalTo: walkButton.rightAnchor, constant: 20).isActive = true
        walkSubLabel.sizeToFit()
        
        walkButton.centerYAnchor.constraint(equalTo: walkLabel.bottomAnchor).isActive = true
        walkButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        walkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        walkButton.widthAnchor.constraint(equalTo: walkButton.heightAnchor).isActive = true
        
        addSubview(walkTimeButton)
        addSubview(walkTimeLabel)
        
        walkTimeButton.topAnchor.constraint(equalTo: walkSubLabel.bottomAnchor, constant: 20).isActive = true
        walkTimeButton.leftAnchor.constraint(equalTo: walkLabel.leftAnchor).isActive = true
        walkTimeButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        walkTimeButton.widthAnchor.constraint(equalTo: walkTimeButton.heightAnchor).isActive = true
        
        walkTimeLabel.leftAnchor.constraint(equalTo: walkTimeButton.rightAnchor, constant: 20).isActive = true
        walkTimeLabel.centerYAnchor.constraint(equalTo: walkTimeButton.centerYAnchor).isActive = true
        walkTimeLabel.sizeToFit()
        
        let line = Line()
        addSubview(line)
        line.anchor(top: walkTimeLabel.bottomAnchor, left: walkLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(walkNavigationButton)
        addSubview(walkNavigationLabel)
        
        walkNavigationButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        walkNavigationButton.leftAnchor.constraint(equalTo: walkLabel.leftAnchor).isActive = true
        walkNavigationButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        walkNavigationButton.widthAnchor.constraint(equalTo: driveNavigationButton.heightAnchor).isActive = true
        
        walkNavigationLabel.leftAnchor.constraint(equalTo: walkNavigationButton.rightAnchor, constant: 20).isActive = true
        walkNavigationLabel.centerYAnchor.constraint(equalTo: walkNavigationButton.centerYAnchor).isActive = true
        walkNavigationLabel.sizeToFit()
        
        let line2 = Line()
        addSubview(line2)
        line2.anchor(top: walkNavigationLabel.bottomAnchor, left: walkLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        addSubview(dottedWalkLine)
        dottedWalkLine.centerXAnchor.constraint(equalTo: walkButton.centerXAnchor).isActive = true
        dottedWalkLine.topAnchor.constraint(equalTo: walkButton.bottomAnchor, constant: 8).isActive = true
        dottedWalkLine.widthAnchor.constraint(equalToConstant: 6).isActive = true
        dottedWalkLine.heightAnchor.constraint(equalToConstant: 122).isActive = true
        
    }
    
    var arriveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "purchaseArrive")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var arriveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Arrive at Mission Bay"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var arriveSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "9:45 pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    func setupArrive() {
        
        addSubview(arriveButton)
        addSubview(arriveLabel)
        addSubview(arriveSubLabel)
        
        arriveLabel.topAnchor.constraint(equalTo: dottedWalkLine.bottomAnchor, constant: 8).isActive = true
        arriveLabel.leftAnchor.constraint(equalTo: arriveButton.rightAnchor, constant: 20).isActive = true
        arriveLabel.sizeToFit()
        
        arriveSubLabel.topAnchor.constraint(equalTo: arriveLabel.bottomAnchor).isActive = true
        arriveSubLabel.leftAnchor.constraint(equalTo: arriveButton.rightAnchor, constant: 20).isActive = true
        arriveSubLabel.sizeToFit()
        
        arriveButton.centerYAnchor.constraint(equalTo: arriveLabel.bottomAnchor).isActive = true
        arriveButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        arriveButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        arriveButton.widthAnchor.constraint(equalTo: arriveButton.heightAnchor).isActive = true
        
        addSubview(showMoreButton)
        showMoreButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 56)
        
        addSubview(showLessButton)
        showLessButton.anchor(top: tripLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 120, height: 30)
        
        addSubview(spacer)
         spacer.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        
    }
    
    var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.alpha = 0
        button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = Theme.LINE_GRAY
        button.addSubview(line)
        
        return button
    }()
    
    var showLessButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show less", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .right
        button.alpha = 0
        button.addTarget(self, action: #selector(showLess), for: .touchUpInside)
        
        return button
    }()
    
    @objc func showMore() {
        delegate?.expandTrip()
        UIView.animate(withDuration: animationIn) {
            self.showLessButton.alpha = 1
            self.showMoreButton.alpha = 0
            self.shareButton.alpha = 0
            
            self.arriveButton.alpha = 1
            self.arriveLabel.alpha = 1
            self.arriveSubLabel.alpha = 1
            
            self.walkButton.alpha = 1
            self.walkLabel.alpha = 1
            self.walkSubLabel.alpha = 1
            self.walkTimeButton.alpha = 1
            self.walkTimeLabel.alpha = 1
            self.walkNavigationButton.alpha = 1
            self.walkNavigationLabel.alpha = 1
            self.dottedWalkLine.alpha = 1
            
            self.parkTimeButton.alpha = 1
            self.parkTimeLabel.alpha = 1
            self.parkNavigationButton.alpha = 1
            self.parkNavigationLabel.alpha = 1
            self.dottedParkLine.alpha = 1
        }
    }
    
    @objc func showLess() {
        delegate?.minimizeTrip()
        UIView.animate(withDuration: animationIn) {
            self.showLessButton.alpha = 0
            self.showMoreButton.alpha = 1
            self.shareButton.alpha = 1
            
            self.arriveButton.alpha = 0
            self.arriveLabel.alpha = 0
            self.arriveSubLabel.alpha = 0
            
            self.walkButton.alpha = 0
            self.walkLabel.alpha = 0
            self.walkSubLabel.alpha = 0
            self.walkTimeButton.alpha = 0
            self.walkTimeLabel.alpha = 0
            self.walkNavigationButton.alpha = 0
            self.walkNavigationLabel.alpha = 0
            self.dottedWalkLine.alpha = 0
            
            self.parkTimeButton.alpha = 0
            self.parkTimeLabel.alpha = 0
            self.parkNavigationButton.alpha = 0
            self.parkNavigationLabel.alpha = 0
            self.dottedParkLine.alpha = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

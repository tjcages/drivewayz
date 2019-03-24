//
//  NavigationTopViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationTopViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        
        return view
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "9:50"
        label.font = Fonts.SSPRegularH0
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "12:50"
        label.font = Fonts.SSPRegularH0
        label.textAlignment = .right
        
        return label
    }()
    
    var timeLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.LIGHT_BLUE.withAlphaComponent(0.8)
        label.text = "4h 24m"
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return label
    }()
    
    var leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE.darker(by: 2)
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = Theme.OFF_WHITE.darker(by: 2)
        circle.layer.cornerRadius = 3
        view.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 6).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
        
        return view
    }()
    
    var rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE.darker(by: 1)
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = Theme.OFF_WHITE.darker(by: 1)
        circle.layer.cornerRadius = 3
        view.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 6).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
        
        return view
    }()
    
    var arriveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.7)
        label.text = "arrive"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var leaveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.7)
        label.text = "depart"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "1065 University Avenue"
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "8 minute drive"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.DARK_GRAY
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        setupDuration()
        readjustCenter()
    }
    
    var timeLeftCenterAnchor: NSLayoutConstraint!
    var timeLeftWidthAnchor: NSLayoutConstraint!
    var fromTimeWidthAnchor: NSLayoutConstraint!
    var toTimeWidthAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        container.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        fromTimeWidthAnchor = fromTimeLabel.widthAnchor.constraint(equalToConstant: 100)
            fromTimeWidthAnchor.isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 78).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        container.addSubview(toTimeLabel)
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        toTimeWidthAnchor = toTimeLabel.widthAnchor.constraint(equalToConstant: 100)
            toTimeWidthAnchor.isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 78).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        container.addSubview(timeLeft)
        timeLeftCenterAnchor = timeLeft.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            timeLeftCenterAnchor.isActive = true
        timeLeftWidthAnchor = timeLeft.widthAnchor.constraint(equalToConstant: 100)
            timeLeftWidthAnchor.isActive = true
        timeLeft.centerYAnchor.constraint(equalTo: fromTimeLabel.centerYAnchor).isActive = true
        timeLeft.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(leftLine)
        leftLine.rightAnchor.constraint(equalTo: timeLeft.leftAnchor, constant: -12).isActive = true
        leftLine.leftAnchor.constraint(equalTo: fromTimeLabel.rightAnchor, constant: 12).isActive = true
        leftLine.centerYAnchor.constraint(equalTo: timeLeft.centerYAnchor).isActive = true
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        container.addSubview(rightLine)
        rightLine.leftAnchor.constraint(equalTo: timeLeft.rightAnchor, constant: 12).isActive = true
        rightLine.rightAnchor.constraint(equalTo: toTimeLabel.leftAnchor, constant: -12).isActive = true
        rightLine.centerYAnchor.constraint(equalTo: timeLeft.centerYAnchor).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        container.addSubview(arriveLabel)
        arriveLabel.leftAnchor.constraint(equalTo: fromTimeLabel.leftAnchor, constant: 0).isActive = true
        arriveLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.topAnchor).isActive = true
        arriveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        arriveLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(leaveLabel)
        leaveLabel.rightAnchor.constraint(equalTo: toTimeLabel.rightAnchor, constant: 0).isActive = true
        leaveLabel.bottomAnchor.constraint(equalTo: toTimeLabel.topAnchor).isActive = true
        leaveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        leaveLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(spotLocatingLabel)
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotLocatingLabel.topAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor, constant: 24).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(distanceLabel)
        distanceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -8).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func readjustCenter() {
        if let leftText = fromTimeLabel.text, let rightText = toTimeLabel.text, var timeText = timeLeft.text {
            timeText = timeText.replacingOccurrences(of: " hrs", with: "h")
            timeText = timeText.replacingOccurrences(of: " hr", with: "h")
            timeText = timeText.replacingOccurrences(of: " min", with: "m")
            self.timeLeft.text = timeText
            let leftWidth = leftText.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH0)
            let rightWidth = rightText.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH0)
            let difference = leftWidth - rightWidth
            self.timeLeftCenterAnchor.constant = difference/2
            self.timeLeftWidthAnchor.constant = timeText.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH3)
            self.fromTimeWidthAnchor.constant = leftWidth
            self.toTimeWidthAnchor.constant = rightWidth
            self.view.layoutIfNeeded()
        }
    }

}

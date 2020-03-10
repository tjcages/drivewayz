//
//  FullDurationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class FullDurationViewController: UIViewController {
    
    var reservationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Booking"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "9:50"
        label.transform = CGAffineTransform(scaleX: 0.9, y: 1.0)
        label.font = Fonts.SSPRegularH0
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "12:50"
        label.transform = CGAffineTransform(scaleX: 0.9, y: 1.0)
        label.font = Fonts.SSPRegularH0
        label.textAlignment = .right
        
        return label
    }()
    
    var timeLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GREEN.withAlphaComponent(0.8)
        label.text = "4h 24m"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return label
    }()
    
    var leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY.darker(by: 2)
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = Theme.BACKGROUND_GRAY.darker(by: 2)
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
        view.backgroundColor = Theme.BACKGROUND_GRAY.darker(by: 1)
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = Theme.BACKGROUND_GRAY.darker(by: 1)
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
        label.textColor = Theme.BLACK.withAlphaComponent(0.5)
        label.text = "arrive"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var leaveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.5)
        label.text = "depart"
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        readjustCenter()
    }
    
    func readjustCenter() {
        if let leftText = fromTimeLabel.text, let rightText = toTimeLabel.text, let timeText = timeLeft.text {
            let leftWidth = leftText.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH0)
            let rightWidth = rightText.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH0)
            let difference = leftWidth - rightWidth
            self.timeLeftCenterAnchor.constant = difference/2
            self.timeLeftWidthAnchor.constant = timeText.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH5)
            self.fromTimeWidthAnchor.constant = leftWidth
            self.toTimeWidthAnchor.constant = rightWidth
            self.view.layoutIfNeeded()
        }
    }
    
    var timeLeftCenterAnchor: NSLayoutConstraint!
    var timeLeftWidthAnchor: NSLayoutConstraint!
    var fromTimeWidthAnchor: NSLayoutConstraint!
    var toTimeWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(reservationLabel)
        reservationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        reservationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        reservationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        reservationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        fromTimeWidthAnchor = fromTimeLabel.widthAnchor.constraint(equalToConstant: 100)
            fromTimeWidthAnchor.isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 16).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(toTimeLabel)
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        toTimeWidthAnchor = toTimeLabel.widthAnchor.constraint(equalToConstant: 100)
            toTimeWidthAnchor.isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: reservationLabel.bottomAnchor, constant: 16).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(timeLeft)
        timeLeftCenterAnchor = timeLeft.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            timeLeftCenterAnchor.isActive = true
        timeLeftWidthAnchor = timeLeft.widthAnchor.constraint(equalToConstant: 100)
            timeLeftWidthAnchor.isActive = true
        timeLeft.centerYAnchor.constraint(equalTo: fromTimeLabel.centerYAnchor).isActive = true
        timeLeft.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(leftLine)
        leftLine.rightAnchor.constraint(equalTo: timeLeft.leftAnchor, constant: -12).isActive = true
        leftLine.leftAnchor.constraint(equalTo: fromTimeLabel.rightAnchor, constant: 12).isActive = true
        leftLine.centerYAnchor.constraint(equalTo: timeLeft.centerYAnchor).isActive = true
        leftLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(rightLine)
        rightLine.leftAnchor.constraint(equalTo: timeLeft.rightAnchor, constant: 12).isActive = true
        rightLine.rightAnchor.constraint(equalTo: toTimeLabel.leftAnchor, constant: -12).isActive = true
        rightLine.centerYAnchor.constraint(equalTo: timeLeft.centerYAnchor).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(arriveLabel)
        arriveLabel.leftAnchor.constraint(equalTo: fromTimeLabel.leftAnchor, constant: 6).isActive = true
        arriveLabel.topAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor).isActive = true
        arriveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        arriveLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(leaveLabel)
        leaveLabel.rightAnchor.constraint(equalTo: toTimeLabel.rightAnchor, constant: -6).isActive = true
        leaveLabel.topAnchor.constraint(equalTo: toTimeLabel.bottomAnchor).isActive = true
        leaveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        leaveLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

}

//
//  CalendarOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CalendarOptionsViewController: UIViewController {

    var delegate: handleCalendarHeight?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.clipsToBounds = true
        
        return view
    }()
    
    var scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        label.text = "Tap specific days or days of the week to block out availability on the calendar"
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(scheduleLabel)
        self.view.addSubview(exitButton)
        
        scheduleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        scheduleLabel.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: -32).isActive = true
        scheduleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -4).isActive = true
        scheduleLabel.sizeToFit()
        
        exitButton.centerYAnchor.constraint(equalTo: scheduleLabel.centerYAnchor).isActive = true
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func backButtonPressed() {
        self.delegate?.closeScheduleView()
    }
    
}

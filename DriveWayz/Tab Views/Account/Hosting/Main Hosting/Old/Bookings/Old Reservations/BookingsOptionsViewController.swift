//
//  BookingsOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingsOptionsViewController: UIViewController {
    
    var firstIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "hostDownArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        return button
    }()
    
    var firstLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stays", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var secondIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "hostUpArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.8)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        return button
    }()
    
    var secondLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reservations", for: .normal)
        button.setTitleColor(Theme.GRAY_WHITE_4.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var tabBarSelector: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 3
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    var selectionLineCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(firstIcon)
        firstIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        firstIcon.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        firstIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        firstIcon.heightAnchor.constraint(equalTo: firstIcon.widthAnchor).isActive = true
        
        self.view.addSubview(firstLabel)
        firstLabel.leftAnchor.constraint(equalTo: firstIcon.rightAnchor, constant: 4).isActive = true
        firstLabel.centerYAnchor.constraint(equalTo: firstIcon.centerYAnchor).isActive = true
        firstLabel.sizeToFit()
        
        self.view.addSubview(secondIcon)
        secondIcon.leftAnchor.constraint(equalTo: firstLabel.rightAnchor, constant: 24).isActive = true
        secondIcon.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        secondIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        secondIcon.heightAnchor.constraint(equalTo: secondIcon.widthAnchor).isActive = true
        
        self.view.addSubview(secondLabel)
        secondLabel.leftAnchor.constraint(equalTo: secondIcon.rightAnchor, constant: 4).isActive = true
        secondLabel.centerYAnchor.constraint(equalTo: secondIcon.centerYAnchor).isActive = true
        secondLabel.sizeToFit()
        
        
        self.view.addSubview(tabBarSelector)
        tabBarSelector.centerYAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        selectionLineCenterAnchor = tabBarSelector.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 28)
            selectionLineCenterAnchor.isActive = true
        tabBarSelector.heightAnchor.constraint(equalToConstant: 6).isActive = true
        tabBarSelector.widthAnchor.constraint(equalToConstant: 74).isActive = true
        
    }
    
}

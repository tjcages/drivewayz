//
//  BookingDurationViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingDurationViewController: UIViewController {
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "time")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var leaveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leave at"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("9:45 PM", for: .normal)
        button.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Make sure to check in once you have arrived..."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()

    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 45
        let image = UIImage(named: "Green Scene")
        view.image = image
        
        return view
    }()
    
    var expandButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Expand", for: .normal)
        label.setTitleColor(Theme.BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(timeButton)
        timeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 42).isActive = true
        timeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        timeButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        timeButton.heightAnchor.constraint(equalTo: timeButton.widthAnchor).isActive = true
        
        self.view.addSubview(leaveLabel)
        leaveLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 8).isActive = true
        leaveLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        leaveLabel.sizeToFit()
        
        self.view.addSubview(durationButton)
        durationButton.leftAnchor.constraint(equalTo: leaveLabel.rightAnchor, constant: 6).isActive = true
        durationButton.bottomAnchor.constraint(equalTo: leaveLabel.bottomAnchor, constant: 8).isActive = true
        durationButton.sizeToFit()
        
        self.view.addSubview(destinationLabel)
        self.view.addSubview(spotIcon)
        destinationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: leaveLabel.bottomAnchor, constant: 8).isActive = true
        destinationLabel.rightAnchor.constraint(equalTo: spotIcon.leftAnchor, constant: -24).isActive = true
        destinationLabel.sizeToFit()
        
        spotIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        spotIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spotIcon.heightAnchor.constraint(equalToConstant: 90).isActive = true
        spotIcon.widthAnchor.constraint(equalTo: spotIcon.heightAnchor).isActive = true
        
        self.view.addSubview(expandButton)
        expandButton.topAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: -8).isActive = true
        expandButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        expandButton.sizeToFit()
        
    }

}

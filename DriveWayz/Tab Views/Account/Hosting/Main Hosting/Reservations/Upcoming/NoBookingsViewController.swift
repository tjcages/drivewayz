//
//  NoBookingsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NoBookingsViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4), bottomColor: Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 140)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "flat-magnifier")
        view.image = image
        
        return view
    }()
    
    var noMessagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No upcoming bookings"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 8
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.addSubview(iconImageView)
        self.view.addSubview(noMessagesLabel)
        
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: noMessagesLabel.topAnchor, constant: -24).isActive = true
        
        iconImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        noMessagesLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        noMessagesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noMessagesLabel.sizeToFit()
        
    }
    
}

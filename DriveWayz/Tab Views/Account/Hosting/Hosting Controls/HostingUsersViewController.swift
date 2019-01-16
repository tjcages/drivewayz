//
//  HostingUsersViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingUsersViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "TOTAL GUESTS"
        
        return label
    }()
    
    var guestDestination: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPExtraLarge
        label.text = "92"
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        container.addSubview(destinationLabel)
        destinationLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        destinationLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        destinationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(guestDestination)
        guestDestination.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        guestDestination.widthAnchor.constraint(equalToConstant: (guestDestination.text?.width(withConstrainedHeight: 50, font: Fonts.SSPExtraLarge))!).isActive = true
        guestDestination.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        guestDestination.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}

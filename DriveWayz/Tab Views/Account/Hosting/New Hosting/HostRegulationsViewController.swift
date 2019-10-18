//
//  HostRegulationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostRegulationsViewController: UIViewController {
    
    var informationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Read our hosting policies here", for: .normal)
        button.setTitleColor(Theme.BLUE.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(informationButton)
        informationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        informationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}

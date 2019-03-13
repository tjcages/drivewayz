//
//  FullCostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class FullCostViewController: UIViewController {
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "Discover 4422"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var totalPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$9.38"
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(costLabel)
        costLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        costLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        costLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(totalPrice)
        totalPrice.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        totalPrice.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        totalPrice.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        totalPrice.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}

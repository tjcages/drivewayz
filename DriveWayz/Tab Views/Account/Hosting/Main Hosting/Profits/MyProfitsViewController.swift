//
//  MyProfitsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MyProfitsViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var profitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My wallet"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var profitsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.00"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPBoldH0
        
        return label
    }()

    var transferButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 4
        button.setTitle("Transfer", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var gradientBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLUE, bottomColor: Theme.LIGHT_BLUE)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        
        setupViews()
    }
    

    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(profitsLabel)
        profitsLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profitsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        profitsLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        profitsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(profitsAmount)
        profitsAmount.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profitsAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        profitsAmount.topAnchor.constraint(equalTo: profitsLabel.bottomAnchor, constant: 0).isActive = true
        profitsAmount.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        container.addSubview(gradientBackground)
        gradientBackground.topAnchor.constraint(equalTo: profitsAmount.bottomAnchor, constant: 16).isActive = true
        gradientBackground.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        gradientBackground.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        gradientBackground.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        container.addSubview(transferButton)
        transferButton.centerYAnchor.constraint(equalTo: profitsAmount.centerYAnchor, constant: -8).isActive = true
        transferButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    
    }

}

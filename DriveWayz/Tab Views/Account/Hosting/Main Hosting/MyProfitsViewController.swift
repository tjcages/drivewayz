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
        label.text = "Total profits"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var profitsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$259.90"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var parkersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total parkers"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var parkersAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var hoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total hours"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var hoursAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "17h 30 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Avg. distance"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var distanceAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.45 mi"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
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
        button.alpha = 0
        
        return button
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
        
        container.addSubview(line)
        line.topAnchor.constraint(equalTo: profitsAmount.bottomAnchor, constant: 16).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(parkersLabel)
        parkersLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        parkersLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkersLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        parkersLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hoursLabel)
        hoursLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        hoursLabel.widthAnchor.constraint(equalToConstant: (hoursLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5))!).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(distanceLabel)
        distanceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: (distanceLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5))!).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(parkersAmount)
        parkersAmount.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        parkersAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkersAmount.topAnchor.constraint(equalTo: parkersLabel.bottomAnchor, constant: 2).isActive = true
        parkersAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hoursAmount)
        hoursAmount.leftAnchor.constraint(equalTo: hoursLabel.leftAnchor).isActive = true
        hoursAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        hoursAmount.topAnchor.constraint(equalTo: parkersLabel.bottomAnchor, constant: 2).isActive = true
        hoursAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(distanceAmount)
        distanceAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        distanceAmount.leftAnchor.constraint(equalTo: distanceLabel.leftAnchor).isActive = true
        distanceAmount.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 2).isActive = true
        distanceAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(transferButton)
        transferButton.centerYAnchor.constraint(equalTo: profitsAmount.centerYAnchor, constant: -8).isActive = true
        transferButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }

}

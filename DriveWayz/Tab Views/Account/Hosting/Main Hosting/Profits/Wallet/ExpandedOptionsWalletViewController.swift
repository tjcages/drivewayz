//
//  ExpandedOptionsWalletViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedOptionsWalletViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var manageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Transfer to bank", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Add funds", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 8
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        container.addSubview(manageButton)
        manageButton.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        manageButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        manageButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        manageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: manageButton.bottomAnchor).isActive = true
        editButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(firstLine)
        firstLine.centerYAnchor.constraint(equalTo: manageButton.bottomAnchor).isActive = true
        firstLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        self.view.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
}

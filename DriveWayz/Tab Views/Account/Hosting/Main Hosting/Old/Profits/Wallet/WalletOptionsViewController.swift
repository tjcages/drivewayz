//
//  WalletOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class WalletOptionsViewController: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var linkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Link payout method", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        let icon = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.DarkPink
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        return button
    }()
    
    var manageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Manage balance", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.alpha = 0
        
        return button
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Change payout method", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var transactionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("View transactions", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var lockButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Report issue", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 8
        button.setTitle("Delete account", for: .normal)
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        
        return button
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var thirdLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
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
    
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.addSubview(linkButton)
        container.addSubview(manageButton)
        container.addSubview(editButton)
        container.addSubview(transactionsButton)
        container.addSubview(lockButton)
        
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 240)
            containerHeightAnchor.isActive = true
        
        linkButton.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        linkButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        linkButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        linkButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        manageButton.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        manageButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        manageButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        manageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        editButton.topAnchor.constraint(equalTo: manageButton.bottomAnchor).isActive = true
        editButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        transactionsButton.topAnchor.constraint(equalTo: editButton.bottomAnchor).isActive = true
        transactionsButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        transactionsButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        transactionsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        lockButton.topAnchor.constraint(equalTo: transactionsButton.bottomAnchor).isActive = true
        lockButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        lockButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        lockButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(firstLine)
        firstLine.centerYAnchor.constraint(equalTo: manageButton.bottomAnchor).isActive = true
        firstLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.addSubview(secondLine)
        secondLine.centerYAnchor.constraint(equalTo: editButton.bottomAnchor).isActive = true
        secondLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        secondLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        secondLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        container.addSubview(thirdLine)
        thirdLine.centerYAnchor.constraint(equalTo: transactionsButton.bottomAnchor).isActive = true
        thirdLine.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        thirdLine.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        thirdLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        self.view.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.noAccount()
    }
    
    func noAccount() {
        self.containerHeightAnchor.constant = 60
        UIView.animate(withDuration: animationIn) {
            self.manageButton.alpha = 0
            self.deleteButton.alpha = 0
            self.linkButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func openAccount() {
        self.containerHeightAnchor.constant = 240
        UIView.animate(withDuration: animationOut) {
            self.manageButton.alpha = 1
            self.deleteButton.alpha = 1
            self.linkButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

}

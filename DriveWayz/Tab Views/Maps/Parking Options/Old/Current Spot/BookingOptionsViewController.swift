//
//  BookingOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingOptionsViewController: UIViewController {
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Extend duration", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandDuration: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Review my payment", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandPayment: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var issueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Have an issue with the spot?", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandIssue: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var problemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Report a problem", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandProblem: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var endButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End booking", for: .normal)
        button.setTitleColor(Theme.SALMON, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
    
        self.view.addSubview(durationButton)
        durationButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        durationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(expandDuration)
        expandDuration.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        expandDuration.centerYAnchor.constraint(equalTo: durationButton.centerYAnchor).isActive = true
        expandDuration.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandDuration.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.topAnchor.constraint(equalTo: durationButton.bottomAnchor).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        paymentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(expandPayment)
        expandPayment.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        expandPayment.centerYAnchor.constraint(equalTo: paymentButton.centerYAnchor).isActive = true
        expandPayment.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandPayment.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.view.addSubview(issueButton)
        issueButton.topAnchor.constraint(equalTo: paymentButton.bottomAnchor).isActive = true
        issueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        issueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        issueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(expandIssue)
        expandIssue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        expandIssue.centerYAnchor.constraint(equalTo: issueButton.centerYAnchor).isActive = true
        expandIssue.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandIssue.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.view.addSubview(problemButton)
        problemButton.topAnchor.constraint(equalTo: issueButton.bottomAnchor).isActive = true
        problemButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        problemButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        problemButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(expandProblem)
        expandProblem.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        expandProblem.centerYAnchor.constraint(equalTo: problemButton.centerYAnchor).isActive = true
        expandProblem.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandProblem.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.view.addSubview(endButton)
        endButton.topAnchor.constraint(equalTo: problemButton.bottomAnchor).isActive = true
        endButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        endButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        endButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}

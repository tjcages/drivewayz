//
//  NavigationOptionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationOptionsView: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()

    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Extend duration", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5

        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Review my payment", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = lineColor
        button.addSubview(view)
        
        return button
    }()

    var issueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Have an issue with the spot?", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = lineColor
        button.addSubview(view)
        
        return button
    }()
    
    var problemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Report a problem", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = lineColor
        button.addSubview(view)
        
        return button
    }()

    var endButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End booking", for: .normal)
        button.setTitleColor(Theme.STRAWBERRY_PINK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = lineColor
        button.addSubview(view)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        container.addSubview(durationButton)
        durationButton.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        durationButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        durationButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        durationButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        container.addSubview(paymentButton)
        paymentButton.topAnchor.constraint(equalTo: durationButton.bottomAnchor).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        paymentButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        container.addSubview(issueButton)
        issueButton.topAnchor.constraint(equalTo: paymentButton.bottomAnchor).isActive = true
        issueButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        issueButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        issueButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        container.addSubview(problemButton)
        problemButton.topAnchor.constraint(equalTo: issueButton.bottomAnchor).isActive = true
        problemButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        problemButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        problemButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        container.addSubview(endButton)
        endButton.topAnchor.constraint(equalTo: problemButton.bottomAnchor).isActive = true
        endButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        endButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        endButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
}

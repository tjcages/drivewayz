//
//  HamburgerMenu.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var hamburgerButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.alpha = 0
    
    return button
}()

var hamburgerWidthAnchor: NSLayoutConstraint!

var hamburgerView1: UIView = {
    let view1 = UIView()
    view1.translatesAutoresizingMaskIntoConstraints = false
    view1.backgroundColor = Theme.DARK_GRAY
    view1.layer.cornerRadius = 1.75
    
    return view1
}()

var hamburgerView2: UIView = {
    let view2 = UIView()
    view2.translatesAutoresizingMaskIntoConstraints = false
    view2.backgroundColor = Theme.DARK_GRAY
    view2.layer.cornerRadius = 1.75
    
    return view2
}()

var hamburgerView3: UIView = {
    let view3 = UIView()
    view3.translatesAutoresizingMaskIntoConstraints = false
    view3.backgroundColor = Theme.DARK_GRAY
    view3.layer.cornerRadius = 1.75
    
    return view3
}()

func createHamburgerButton() {
    
    hamburgerButton.addSubview(hamburgerView1)
    hamburgerView1.topAnchor.constraint(equalTo: hamburgerButton.topAnchor, constant: 22).isActive = true
    hamburgerView1.leftAnchor.constraint(equalTo: hamburgerButton.leftAnchor, constant: 16).isActive = true
    hamburgerView1.rightAnchor.constraint(equalTo: hamburgerButton.rightAnchor, constant: -24).isActive = true
    hamburgerView1.heightAnchor.constraint(equalToConstant: 3.5).isActive = true
    
    hamburgerButton.addSubview(hamburgerView2)
    hamburgerView2.bottomAnchor.constraint(equalTo: hamburgerButton.bottomAnchor, constant: -22).isActive = true
    hamburgerView2.leftAnchor.constraint(equalTo: hamburgerButton.leftAnchor, constant: 16).isActive = true
    hamburgerWidthAnchor = hamburgerView2.rightAnchor.constraint(equalTo: hamburgerButton.rightAnchor, constant: -28)
        hamburgerWidthAnchor.isActive = true
    hamburgerView2.heightAnchor.constraint(equalToConstant: 3.5).isActive = true
    
    hamburgerButton.addSubview(hamburgerView3)
    hamburgerView3.centerYAnchor.constraint(equalTo: hamburgerButton.centerYAnchor).isActive = true
    hamburgerView3.leftAnchor.constraint(equalTo: hamburgerButton.leftAnchor, constant: 16).isActive = true
    hamburgerView3.rightAnchor.constraint(equalTo: hamburgerButton.rightAnchor, constant: -24).isActive = true
    hamburgerView3.heightAnchor.constraint(equalToConstant: 3.5).isActive = true
    
}
